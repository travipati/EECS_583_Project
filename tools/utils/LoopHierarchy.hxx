#ifndef LOOP_HIERARCHY_H
#define LOOP_HIERARCHY_H

#include <iterator>
#include <inttypes.h>
#include <iostream>
#include <stdlib.h>
#include <iterator>
#include <cassert>
#include <vector> //// ajamshid: added 9/4/13

#include "CircularQueue.hxx"

using namespace std;
using namespace Collections;

namespace Loop {

    static const uint64_t DEFAULT_DEPENDENCE_DISTANCE = 5;

    template<class T, int maxDepDist = DEFAULT_DEPENDENCE_DISTANCE>
    class LoopInfo {
    public:
	circular_buffer<uint64_t> iteration_time_stamps;
	uint64_t invocation_time_stamp;
	uint16_t loop_id;
	T item;

	LoopInfo() : iteration_time_stamps(maxDepDist), invocation_time_stamp(0), loop_id(0), item() { 
	}

	void reset(uint64_t loop, uint64_t time_stamp) {
	    this->loop_id = loop;
	    this->invocation_time_stamp = time_stamp;
	    this->iteration_time_stamps.clear();
	}

	T & getItem() {
	    return item;
	}

	void setItem(const T &item) {
	    this->item = item;
	}

	void iteration(uint64_t time_stamp) {
	    this->iteration_time_stamps.push_back(time_stamp);
	}
    };

    static const uint64_t DEFAULT_LOOP_DEPTH = 1024;

    template <class T,
	      int maxLoopDepth = DEFAULT_LOOP_DEPTH,
	      int maxDepDistance = DEFAULT_DEPENDENCE_DISTANCE>
    class LoopHierarchy {
    public:
	typedef LoopInfo<T, maxDepDistance> LoopInfoType;

	typedef typename vector<LoopInfoType>::iterator iterator;

	typedef typename vector<LoopInfoType>::reverse_iterator reverse_iterator;

	uint32_t max_depth;
	
	uint32_t current_depth;

	vector<LoopInfoType> loop_info;

	LoopHierarchy() : max_depth(0), current_depth(-1), loop_info(maxLoopDepth) {
	    enterLoop(0, 0);
	}
	
	void enterLoop(uint64_t loop_id, uint64_t timestamp) {
	    this->current_depth++;
	    this->loop_info.at(this->current_depth).reset(loop_id, timestamp);

	    if (this->current_depth > this->max_depth) {
		this->max_depth = this->current_depth;
	    }
		//	cerr << " + " << current_depth << " ";
	}

	void exitLoop() {
	    this->current_depth--;
		//	cerr << " - " << current_depth << " ";
			//assert (current_depth >=0 && current_depth <=64 );    //PC,2/3/2009
	}

	void loopIteration(uint64_t time_stamp) {
	    this->getCurrentLoop().iteration(time_stamp);
	}

	LoopInfoType & getCurrentLoop() {
		try {                                                    // -PC , 2/5/2009 add catch exception
	    this->loop_info.at(this->current_depth);
		}catch (std::out_of_range outOfRange){
			cout << "\n\nException: " << outOfRange.what();
			cout << "\nCurrent Loop Depth: " << current_depth;
		}
    return this->loop_info.at(this->current_depth);
	}

	LoopInfoType & findLoop(uint64_t store_time_stamp) {
	    if (store_time_stamp == 0) {
		return loop_info[0];
	    }

	    for (uint32_t iter = this->current_depth; iter > 0; iter--) {
		if (loop_info[iter].invocation_time_stamp < store_time_stamp)
		    return loop_info[iter];
	    }
	    
	    if (this->loop_info[0].invocation_time_stamp > store_time_stamp) {
		cerr<<"Unexpected time stamp: "<<this->loop_info[0].invocation_time_stamp<<" > "<<store_time_stamp<<endl;
		abort();
	    }

	    return this->loop_info[0];
	}

	uint32_t calculateDistance(LoopInfoType &store_loop, uint64_t store_time_stamp) {
	    circular_buffer<uint64_t>::reverse_iterator iter = store_loop.iteration_time_stamps.rbegin();

	    uint32_t distance = 0;
	    for (; iter != store_loop.iteration_time_stamps.rend(); iter++) {
		if (*iter <= store_time_stamp)
		    break;
		distance++;
	    }

	    return distance;
	}
    };
}

#endif
