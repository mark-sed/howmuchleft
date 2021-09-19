NAME=howmuchleft

all: build clean

build:
	ghc -o $(NAME) $(NAME).hs

clean:
	rm $(NAME).hi
	rm $(NAME).o
