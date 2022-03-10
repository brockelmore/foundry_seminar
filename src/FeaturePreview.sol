// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;


contract Test {

	bool public flag0 = true;
	bool public flag1 = true;

	function set0(int val) public returns (bool){
		if (val % 100 == 0) 
		    flag0 = false;
		return flag0;
	}

	function set1(int val) public returns (bool){
	    if (val % 10 == 0 && !flag0) 
	        flag1 = false;
	    return flag1;
	}
}