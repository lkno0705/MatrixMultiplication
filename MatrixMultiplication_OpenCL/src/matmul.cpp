#include <CL/cl2.hpp>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <chrono>

void MatMul(float* matA, float* matB, float* matC, int m, int n, int k) {
    std::vector<cl::Platform> platforms;
    cl::Platform::get(&platforms);
    if (platforms.size() == 0) {
        std::cout << "No platforms found \n";
        exit(1);
    }

    cl::Platform defaultPlatform = platforms[0];

    std::vector<cl::Device> devices;
    defaultPlatform.getDevices(CL_DEVICE_TYPE_GPU, &devices);
    if (devices.size() == 0) {
        std::cout << "No devices found \n";
        exit(1);
    }

    cl::Device defaultDevice = devices[0];
    cl::Context context(defaultDevice);
    cl::Program::Sources sources;

    std::fstream fileStream;
    fileStream.open("matmul.cl", std::ios::in);
    std::string kernelCode;
    if (fileStream.is_open()) {
        std::ostringstream stringStream;
        stringStream << fileStream.rdbuf();
        kernelCode = stringStream.str();
        fileStream.close();
    } else {
        std::cout << "Could not open kernel \n";
        fileStream.close();
        exit(1);
    }
    sources.push_back({kernelCode.c_str(), kernelCode.length()});

    cl::Program program(context, sources);
    if (program.build({defaultDevice}) != CL_SUCCESS) {
        std::cout << "Error while building kernel: " << program.getBuildInfo<CL_PROGRAM_BUILD_LOG>(defaultDevice) << std::endl;
        exit(1);
    }
    cl::CommandQueue queue(context, defaultDevice);
    cl::Kernel GemmKernel = cl::Kernel(program, "MatMul");

    cl::Buffer bufferA(context, CL_MEM_READ_WRITE, sizeof(float) * k * m);
    cl::Buffer bufferB(context, CL_MEM_READ_WRITE, sizeof(float) * k * n);
    cl::Buffer bufferC(context, CL_MEM_READ_WRITE, sizeof(float) * n * m);

    queue.enqueueWriteBuffer(bufferA, CL_TRUE, 0, sizeof(float) * k * m, matA);
    queue.enqueueWriteBuffer(bufferB, CL_TRUE, 0, sizeof(float) * k * n, matB);
    queue.enqueueWriteBuffer(bufferC, CL_TRUE, 0, sizeof(float) * n * m, matC);

    GemmKernel.setArg(0, bufferA);
    GemmKernel.setArg(1, bufferB);
    GemmKernel.setArg(2, bufferC);
    GemmKernel.setArg(3, m);
    GemmKernel.setArg(4, n);
    GemmKernel.setArg(5, k);

    cl::NDRange globalRange(m, n);
    int localMaxRange = defaultDevice.getInfo<CL_DEVICE_MAX_WORK_ITEM_SIZES>()[0];
    cl::NDRange localRange(32, 32);

    std::cout << "Starting kernel on GPU" << "\n";
    std::chrono::steady_clock::time_point start = std::chrono::steady_clock::now();
    queue.enqueueNDRangeKernel(GemmKernel, cl::NullRange, globalRange, localRange);
    queue.enqueueReadBuffer(bufferC, CL_TRUE, 0, sizeof(float) * n * m, matC);
    int timeInMs = std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::steady_clock::now() - start).count();
    std::cout << "Kernel finished in: " << timeInMs << "ms" << "\n";
}