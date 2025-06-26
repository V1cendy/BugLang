all: BugLang.l BugLang.y
	clear
	flex -i BugLang.l
	bison BugLang.y
	gcc BugLang.tab.c -o BugLang -lfl -lm
	./BugLang