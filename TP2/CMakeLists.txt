cmake_minimum_required(VERSION 3.26)
project(TP2 C)

set(CMAKE_C_STANDARD 11)

add_executable(TP2 main.c
        functions.c
        functions.h
        auxili.c
        auxili.h
        hillclimbing.c
        hillclimbing.h
        trepacolinas.c
        trepacolinas.h
)
