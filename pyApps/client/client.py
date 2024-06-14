import grpc

import service_pb2
import service_pb2_grpc

# Simple client app requesting results from math operations to server

def run():
    with grpc.insecure_channel('localhost:50051') as channel:
        stub = service_pb2_grpc.SimetrikServiceStub(channel)

        add_response = stub.Add(service_pb2.MathRequest(num1=10, num2=5))
        print("Addition result: " + str(add_response.result))

        subtract_response = stub.Subtract(service_pb2.MathRequest(num1=10, num2=5))
        print("Subtraction result: " + str(subtract_response.result))

        multiply_response = stub.Multiply(service_pb2.MathRequest(num1=10, num2=5))
        print("Multiplication result: " + str(multiply_response.result))

if __name__ == '__main__':
    run()
