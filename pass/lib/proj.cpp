#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Analysis/ProfileInfo.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "LAMPLoadProfile.h"
#include "LAMPProfiling.h"
#include <fstream>
#include <vector>
#include <algorithm>
#include <string>
#include <set>
#include <iostream>
using namespace llvm;
using namespace std;
//namespace fuck {
struct branchkill : public FunctionPass {
	static char ID;
	branchkill() : FunctionPass(ID) {}
	virtual bool runOnFunction(Function &F) {
		ProfileInfo * PI;
		vector<BasicBlock *> dead;
		PI = &getAnalysis<ProfileInfo>();
		for (Function::iterator b = F.begin(); b != F.end(); ++b){
			//errs() << " lookin at a bb \n";
			int execount = PI->getExecutionCount(b);

			TerminatorInst * terminst = b->getTerminator();
			int numsucc = terminst->getNumSuccessors();
			vector<double> edgeWeights(numsucc);
			int sum = 0;
			int max = 0;
			BasicBlock * Beastsucc;
			for (int i = 0; i< numsucc; ++i){
				BasicBlock * succ = terminst->getSuccessor(i);
				int weight = PI->getEdgeWeight(make_pair(b, succ));
				//errs() << " adding a weight " << weight << '\n';
				sum += weight;
				if (weight > max){
					Beastsucc = succ;
					max = weight;
				}
			}

			if (max == sum) {
				//errs() << "thinking about chageing branch with numsucc = " << numsucc << "\n";
				if (numsucc <= 1) {
					continue;
				}
				for (int i = 0; i < numsucc; ++i){
					BasicBlock * succ = terminst->getSuccessor(i);
					if (succ != Beastsucc){
						dead.push_back(succ);
						succ->removePredecessor(b);
					}
				}
				//	errs() << "changing a branch, formally had " << b->getTerminator()->getNumSuccessors() << " successors \n";
				b->getTerminator()->eraseFromParent(); // delete the  unconditionalbranch added by SplitBlock, we are adding our own
				BranchInst::Create(Beastsucc, b);

				b = F.begin(); //we modified the CFG, so restart iterator or things get fucked
			}
		}
		return true; //fixme return true only if we changed anything
	}
	void getAnalysisUsage(AnalysisUsage &AU) const {
		AU.addRequired<ProfileInfo>();
	}
};

//todo: make this sink stores also, if it turns out doing this is a good speedup
struct HoistLoads : public LoopPass {

	std::map<Instruction *, int> numTimesExecuted;
	std::map<Instruction *, int> numDeps;

	LoopInfo      *LI;       // Current LoopInfo
	DominatorTree *DT;       // Dominator Tree for the current Loop.
	Loop *CurLoop;           // The current loop we are working on...
	BasicBlock * Preheader;

	static char ID;
	bool changed;

	HoistLoads() : LoopPass(ID) { changed = false; }


	virtual bool runOnLoop(Loop *L, LPPassManager &LPM);
	void MaxHoistRegion(DomTreeNode *N);
	void hoist(Instruction &I);
	/// inSubLoop - Little predicate that returns true if the specified basic
	/// block is in a subloop of the current one, not the current one itself.
	///
	bool inSubLoop(BasicBlock *BB) {
		assert(CurLoop->contains(BB) && "Only valid if BB is IN the loop");
		return LI->getLoopFor(BB) != CurLoop;
	}

	void getAnalysisUsage(AnalysisUsage &AU) const {
		AU.addRequired<ProfileInfo>();
		AU.addRequired<LAMPLoadProfile>();
		AU.addRequired<DominatorTree>();
		AU.addRequired<LoopInfo>();
	}
};

bool HoistLoads::runOnLoop(Loop *L, LPPassManager &LPM){
	CurLoop = L;
	Preheader = L->getLoopPreheader();

	LI = &getAnalysis<LoopInfo>();
	DT = &getAnalysis<DominatorTree>();
	LAMPLoadProfile * LPI = &getAnalysis<LAMPLoadProfile>();
	ProfileInfo * PI = &getAnalysis<ProfileInfo>();

	for (Loop::block_iterator b = L->block_begin(); b != L->block_end(); ++b){
		for (BasicBlock::iterator i = (**b).begin(); i != (**b).end(); ++i){
			if (LoadInst *LI = dyn_cast<LoadInst>(i)){
				numTimesExecuted[i] = PI->getExecutionCount(*b); // not used atm, but might be useful later
				for (auto it = LPI->DepToTimesMap.begin(); it != LPI->DepToTimesMap.end(); ++it){
					if (CurLoop->contains(it->first->first->getParent()) && CurLoop->contains(it->first->second->getParent())) { //only want to keep track of dependencys within the loop, if you alis with somethign outside the loop feel free to hoist
						if (LPI->InstToIdMap[it->first->first] == LPI->InstToIdMap[i]){
							numDeps[i] += it->second;
						}
					}
				 //	else {		errs() << "DOES THIS DEP TO TIMES MAP ONLY GIVE STUFF IN THE LOOP? I GUESS NOT \n";	} // this else is often triggered
				}
			}
		}
	}
	assert(Preheader && "RUN LOOP SIMPLIFY BEFORE THIS PASS");
	MaxHoistRegion(DT->getNode(L->getHeader()));
	

	return changed;
}


void HoistLoads::MaxHoistRegion(DomTreeNode *N) {
	assert(N != 0 && "Null dominator tree node?");
	BasicBlock *BB = N->getBlock();
	// If this subregion is not in the top level loop at all, exit.
	if (!CurLoop->contains(BB)) return;

	// Only need to process the contents of this block if it is not part of a
	// subloop (which would already have been processed).
	if (!inSubLoop(BB)){
		for (BasicBlock::iterator II = BB->begin(), E = BB->end(); II != E;) {
			Instruction &I = *II++;

			/* FIXME:::::	normal LICM pass thinks constant folding is better than hoisting. maybe want to uncomment this at some point

			// Try constant folding this instruction.  If all the operands are
			// constants, it is technically hoistable, but it would be better to just
			// fold it.
			if (Constant *C = ConstantFoldInstruction(&I, TD, TLI)) {
				errs() << "constant folding something. does this ever happen? \n";
				DEBUG(dbgs() << "SLICM folding inst: " << I << "  --> " << *C << '\n');
				CurAST->copyValue(&I, C);
				CurAST->deleteValue(&I);
				I.replaceAllUsesWith(C);
				I.eraseFromParent();
				continue;
			}
			*/
			if (LoadInst *LI = dyn_cast<LoadInst>(&I)){
				//if (CurLoop->hasLoopInvariantOperands(&I) && canSinkOrHoistInst(I) && isSafeToExecuteUnconditionally(I)){ // old restrictions
				if (CurLoop->hasLoopInvariantOperands(&I) && numDeps[LI] == 0){
					errs() << "Hoisting a load! \n";
					hoist(I);
				}
			}
		}
	}
	const std::vector<DomTreeNode*> &Children = N->getChildren();
	for (unsigned i = 0, e = Children.size(); i != e; ++i)
		MaxHoistRegion(Children[i]);
}

/// hoist - When an instruction is found to only use loop invariant operands
/// that is safe to hoist, this instruction is called to do the dirty work.
///
void HoistLoads::hoist(Instruction &I) {
	DEBUG(dbgs() << "SLICM hoisting to " << Preheader->getName() << ": "
		<< I << "\n");
	//errs() << "SLICM hoisting to " << Preheader->getName() << ": "<< I << "\n";
	// Move the new node to the Preheader, before its terminator.
	I.moveBefore(Preheader->getTerminator());

	//if (isa<LoadInst>(I)) ++NumMovedLoads;
	//else if (isa<CallInst>(I)) ++NumMovedCalls;
	//++NumHoisted;
	changed = true;
}

char branchkill::ID = 0;
char HoistLoads::ID = 1;

static RegisterPass<branchkill> Y("branchkill", "branchkill", false, false);
static RegisterPass<HoistLoads> X("HoistLoads", "Hello World Pass", false, false);



