# c3c=/home/ali/mnt/project/code/everything/c3c/build/c3c
c3c=/home/ali/mnt/project/code/git/c3c/build/c3c
# c3c=~/c3c/c3c

build:
	${c3c} build

debug:
	${c3c} build -g
	gdb ./build/c3_craft

run:
	${c3c} run

runWithDebugInfo:
	${c3c} run --sanitize=address -g
