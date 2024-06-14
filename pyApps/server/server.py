import grpc
from concurrent import futures
import time

import service_pb2
import service_pb2_grpc

# Simple grpc server serving math functions 

class SimetrikServiceServicer(service_pb2_grpc.SimetrikServiceServicer):
    def Add(self, request, context):
        response = service_pb2.MathResponse()
        response.result = request.num1 + request.num2
        return response

    def Subtract(self, request, context):
        response = service_pb2.MathResponse()
        response.result = request.num1 - request.num2
        return response

    def Multiply(self, request, context):
        response = service_pb2.MathResponse()
        response.result = request.num1 * request.num2
        return response

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    service_pb2_grpc.add_SimetrikServiceServicer_to_server(SimetrikServiceServicer(), server)
    server.add_insecure_port('[::]:50051')
    server.start()
    print("Server started on port 50051.")
    try:
        while True:
            time.sleep(86400)
    except KeyboardInterrupt:
        server.stop(0)

if __name__ == '__main__':
    serve()

