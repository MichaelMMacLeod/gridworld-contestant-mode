#!/bin/bash

# Put contestant *.java files in ./CONTESTANT_PARTS
# ie, 
#   ./CONTESTANT_PARTS/Hopper.java
#   and
#   ./CONTESTANT_PARTS/Jumper.java
#   will be both placed in the grid.

echo "Michael's GridWorld Contestant Linker"
echo ""
echo "Usage: ./LINK_PARTS.sh [rows columns] [-fast]"
echo "  rows     the number of rows of the grid (default 20)"
echo "  columns  the number of columns of the grid (default 20)"
echo "  -fast    without -fast, LINK_PARTS will explicitely compile GridWorld"
echo ""

# Bugs:
#   GridWorld sometimes starts with a blank grid when it should start with one that has
#   actors in it. Restarting with '-fast' afterwards should probably work.

### cleanup, if necessary 

rm TMP_MAIN 2> /dev/null
rm -rf TMP_CONTESTANT_PARTS 2> /dev/null

### setup the beginning of TMP_MAIN

echo "setting up grid... "

cp ./part/main_start TMP_MAIN

if [[ $1 && $2 ]]; then
    echo " ==> Grid of size $1x$2 selected."
    echo "ActorWorld world = new ActorWorld(new BoundedGrid<Actor>($1, $2));" >> TMP_MAIN
else
    echo " ==> Grid of size 20x20 selected."
    echo "ActorWorld world = new ActorWorld(new BoundedGrid<Actor>(20, 20));" >> TMP_MAIN
fi

echo "ArrayList<Actor> actors = new ArrayList<>();" >> TMP_MAIN

### add contestants to TMP_MAIN

echo "adding contestants..."

mkdir TMP_CONTESTANT_PARTS

cp ./CONTESTANT_PARTS/* ./TMP_CONTESTANT_PARTS
CONTESTANTS=$(ls ./TMP_CONTESTANT_PARTS)

for FILE_NAME in $CONTESTANTS; do
    CLASS_NAME=$(echo $FILE_NAME | cut -d '.' -f 1)

    echo " ==> $CLASS_NAME"

    echo "package TMP_CONTESTANT_PARTS;" | cat - "./TMP_CONTESTANT_PARTS/$FILE_NAME" > tmp && mv tmp "./TMP_CONTESTANT_PARTS/$FILE_NAME"
    echo "actors.add(new TMP_CONTESTANT_PARTS.$CLASS_NAME());" >> TMP_MAIN
done

### setup the end of TMP_MAIN

cat ./part/main_end >> TMP_MAIN

### remove temp files

mv TMP_MAIN Main.java

### compile

echo "compiling..."

if [[ $1 != "-fast" ]] && [[ $3 != "-fast" ]]; then
    # GridWorld uses nasty deprecated features or something, so it sometimes throws
    # errors at runtime. Compiling it explicitly seems to fix this problem. But after
    # it's compiled, there's no need to recompile; that's why '-fast' exists.
    echo " ==> info/gridworld/world/*.java"
    javac info/gridworld/world/*.java
    echo " ==> info/gridworld/gui/*.java"
    javac info/gridworld/gui/*.java
    echo " ==> info/gridworld/grid/*.java"
    javac info/gridworld/grid/*.java
    echo " ==> info/gridworld/actor/*.java"
    javac info/gridworld/actor/*.java
fi

echo " ==> Main.java"
javac Main.java

### run

echo "running..."

echo " ==> Main"

java Main
