#include "Mode.hpp"
#include <stdexcept>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

Mode::Mode() : score(0) {

}

Mode Mode::benchmark() {
	Mode r;
	r.name = "benchmark";
	r.kernel = "profanity_score_benchmark";
	return r;
}

Mode Mode::zeros() {
	Mode r = range(0, 0);
	r.name = "zeros";
	return r;
}

static std::string::size_type hexValueNoException(char c) {
	if (c >= 'A' && c <= 'F') {
		c -= 'A' - 'a';
	}

	const std::string hex = "0123456789abcdef";
	const std::string::size_type ret = hex.find(c);
	return ret;
}
static std::string::size_type base58ValueNoException(char c) {
	const std::string hex = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
	const std::string::size_type ret = hex.find(c);
	return ret;
}

static std::string::size_type hexValue(char c) {
	const std::string::size_type ret = hexValueNoException(c);
	if(ret == std::string::npos) {
		throw std::runtime_error("bad hex value");
	}

	return ret;
}

Mode Mode::matching(const std::string strHex) {
	Mode r;
	r.name = "matching";
	r.kernel = "profanity_score_matching";

	std::fill( r.data1, r.data1 + sizeof(r.data1), cl_uchar(0) );
	std::fill( r.data2, r.data2 + sizeof(r.data2), cl_uchar(0) );

	std::ifstream file(strHex);
	if (!file.is_open()) {
        std::cerr << "Failed to open file!" << std::endl;
        std::exit(1);
    }
	std::vector<std::string> lines;
    std::string line;
    while (std::getline(file, line)) {
        lines.push_back(line);
    }

    file.close();
	
	for(auto j = 0; j < 100;j++){
		std::string strHex2 = lines[j];
		printf("Your size is: %d\n",  strHex2.size());
		std::cout << strHex2 << std::endl;
		auto index = 0;
		for( size_t i = 0; i < strHex2.size(); i += 1 ) {
			auto tmpIndex = j*20 + index;
			const auto indexStr = base58ValueNoException(strHex2[i]);
			r.data1[tmpIndex] = indexStr < 58 ? 255 : 0;
			r.data2[tmpIndex] = (cl_uchar)strHex2[i];
			// printf("mask %u val %u\n",r.data1[tmpIndex],r.data2[tmpIndex]);
			++index;
		}
	}
	
	

	return r;
}

Mode Mode::leading(const char charLeading) {

	Mode r;
	r.name = "leading";
	r.kernel = "profanity_score_leading";
	r.data1[0] = static_cast<cl_uchar>(hexValue(charLeading));
	return r;
}

Mode Mode::range(const cl_uchar min, const cl_uchar max) {
	Mode r;
	r.name = "range";
	r.kernel = "profanity_score_range";
	r.data1[0] = min;
	r.data2[0] = max;
	return r;
}

Mode Mode::letters() {
	Mode r = range(10, 15);
	r.name = "letters";
	return r;
}

Mode Mode::numbers() {
	Mode r = range(0, 9);
	r.name = "numbers";
	return r;
}

std::string Mode::transformKernel() const {
	switch (this->target) {
		case ADDRESS:
			return "";
		case CONTRACT:
			return "profanity_transform_contract";
		default:
			throw "No kernel for target";
	}
}

std::string Mode::transformName() const {
	switch (this->target) {
		case ADDRESS:
			return "Address";
		case CONTRACT:
			return "Contract";
		default:
			throw "No name for target";
	}
}

Mode Mode::leadingRange(const cl_uchar min, const cl_uchar max) {
	Mode r;
	r.name = "leadingrange";
	r.kernel = "profanity_score_leadingrange";
	r.data1[0] = min;
	r.data2[0] = max;
	return r;
}

Mode Mode::mirror() {
	Mode r;
	r.name = "mirror";
	r.kernel = "profanity_score_mirror";
	return r;
}

Mode Mode::doubles() {
	Mode r;
	r.name = "doubles";
	r.kernel = "profanity_score_doubles";
	return r;
}
