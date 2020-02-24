import random
import sys

class Matrix:
    def __init__(self, m, n):
        self.m = m
        self.n = n
        self.matrix = [[]]

    def createRandomMatrix(self):
        #print("Creating Matrix")
        for i in range(self.m):
            self.matrix.append([])
            for j in range(self.n):
                self.matrix[i].append(random.randint(0,10))

    def createEmptyMatrix(self):
        for i in range(self.m):
            self.matrix.append([])
            for j in range(self.n):
                self.matrix[i].append(0)

    def printout(self):
        for i in range(self.m):
            for j in range(self.n):
                sys.stdout.write(str(self.matrix[i][j]) + " ")
            sys.stdout.write("\n")
        sys.stdout.write("\n")
