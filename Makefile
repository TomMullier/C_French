all:
	rm -f c_french.exe c_french c_french.lex.cpp c_french.bison.cpp c_french.bison.h
	bison -d -Wcounterexamples c_french.y -o c_french.bison.cpp
	flex -o c_french.lex.cpp c_french.l
	g++ -w c_french.lex.cpp c_french.bison.cpp -o c_french
	ls
	./c_french test.ouiouibaguette