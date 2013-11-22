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
				/*
			//	for (int i = 0; i < dead.size(); i++){
			//		if (pred_begin(dead[i]) == pred_end(dead[i])){
			//			DeleteDeadBlock(dead[i]);
			//		}
			//	}

			//				dead.clear();
				*/

				b = F.begin(); //we modified the CFG, so restart iterator or things get fucked
				/*
				//b->getTerminator()->setCondition(ConstantInt::getTrue(b->getContext()));
				
				////////////////////// AFTER RE REMOVE IT THEN GO BACK TO DELETE DEAD BB AND CHECK TO SEE WHAT HAPPENS
				if (!Beastsucc->getUniquePredecessor()){
				//	errs() << "no unique pred \n";
				}
				if (!MergeBlockIntoPredecessor(Beastsucc, this)){
			//		errs() << "merge failed \n";
				}
				else {
			//		errs() << "merge worked \n";

				}
				*/


			}
			/*
			if ((double)max / (double)sum >= .95) {
			if (numsucc == 1) {
			continue;
			}
			b->getTerminator()->eraseFromParent(); // delete the  unconditionalbranch added by SplitBlock, we are adding our own
			BranchInst::Create(Beastsucc,b);
			}
			*/
			// fucks everything up for some reason
			
		/*	for (Function::iterator b = F.begin(); b != F.end(); ++b){
				if (MergeBlockIntoPredecessor(Beastsucc, this)){
						errs() << "merged blocks sucessfully! \n";
						//b = F.begin();
				}
			}
			*/
			
		}
		return false;
	}
	void getAnalysisUsage(AnalysisUsage &AU) const {
		AU.addRequired<ProfileInfo>();
	}
};
struct hw1LAMP : public FunctionPass {
	static char ID;
	hw1LAMP() : FunctionPass(ID) {}
    virtual bool runOnFunction(Function &F) {
	map<Instruction *, int> numTimesExecuted;
	map<Instruction *, int> numDeps; 
      	LAMPLoadProfile * LPI = &getAnalysis<LAMPLoadProfile>();
	ProfileInfo * PI = &getAnalysis<ProfileInfo>();
      	for(Function::iterator b = F.begin(); b != F.end(); ++b){
		for(BasicBlock::iterator i = b->begin(); i != b->end() ; ++i){
			if(i->getOpcode()==Instruction::Load){ 
				numTimesExecuted[i] = PI->getExecutionCount(b);
	//			if(PI-> getExecutionCount(b) == 0){
	//				errs() << "WHAT THE FLYING FUCK REALLY \n";
	//			}
				for(auto it = LPI->DepToTimesMap.begin(); it!=LPI-> DepToTimesMap.end(); ++it){
					if(LPI->InstToIdMap[it->first->first] == LPI->InstToIdMap[i]){
						numDeps[i] += it->second;	
					}
				}
			}
		}
	}
/*	errs() << "\n\n\n\n\n\n\n\n\n\n\n\n\n";
	for(auto it = LPI->DepToTimesMap.begin(); it!=LPI-> DepToTimesMap.end(); ++it){
		errs() << LPI->InstToIdMap[it->first->first] << "depends on " << LPI->InstToIdMap[it->first->second] << " " << it->second << " times \n";
	}
	errs() << "\n\n\n\n";
	for(auto it= numTimesExecuted.begin(); it!=numTimesExecuted.end(); ++it){
	// 	errs() << LPI->InstToIdMap[it->first] << " has a dependencey fraction of " << numDeps[it->first]/((double)it->second) << '\n';
		errs() << LPI->InstToIdMap[it->first] << " gets executed " << it-> second <<" times , and has "<<  numDeps[it->first] << " dependencies \n";
			
	}
	errs() << "\n\n\n\n";
	*/	
	ofstream ofs;
	ofs.open("ldstats",fstream::app);
	for(auto it= numTimesExecuted.begin(); it!=numTimesExecuted.end(); ++it){
	 	if(it->second == 0){
			ofs << LPI->InstToIdMap[it->first] << " 0\n";
		}
		else {
			ofs << LPI->InstToIdMap[it->first] << " " << numDeps[it->first]/((double)it->second) << '\n';
		}
	}
	return false;
    }
    void getAnalysisUsage(AnalysisUsage &AU) const {
	AU.addRequired<ProfileInfo>();
    	AU.addRequired<LAMPLoadProfile>();
	}
  };
//}

char branchkill::ID = 0;
char hw1LAMP::ID = 1;
static RegisterPass<branchkill> Y("branchkill", "branchkill", false, false);
static RegisterPass<hw1LAMP> X("hw1LAMP", "Hello World Pass", false, false);
