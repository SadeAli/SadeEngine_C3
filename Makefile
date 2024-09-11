c3c=/home/ali/mnt/project/code/everything/c3c/build/c3c
# c3c=~/c3c/c3c

build:
	${c3c} build -l glfw

debug:
	${c3c} build -l glfw -g
	gdb ./build/c3_craft

run:
	${c3c} run -l glfw

runWithDebugInfo:
	${c3c} run -l glfw --sanitize=address -g
