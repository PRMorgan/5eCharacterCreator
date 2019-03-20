# 5eCharacterCreator

**Important:**
*For optimal use of this program, make sure you create a folder to store the npc_builder.exe file in. Upon execution, the program creates four files and will store them wherever your original npc_builder.exe file is. In order to save some headache, just create a folder for your stuff. I promise you'll thank me later.*

This is a tool that will allow you to go through character creation for a Fifth Edition Dungeons and Dragons character. The original purpose of this tool was to provide DMs with a means of character creation that doesn't take an hour and constant flipping between pages. This README was written with the intent to help those who may be interested in using the tool but have no programming experience.

## Table of Contents

1. [Content Avaiable](#content)
2. [How to use this tool](#howto)
3. [What to expect next (a step-by-step guide)](#stepbystep)
4. [Misc.](#misc)
5. [Compiling and building the code on your own](#onyourown)
6. [Looking to contribute to the project?](#contributing)

<a name = "content"/>

## 1. Content Available

1. Races
   - Dwarf (Hill)
   - Elf (High)
   - Halfling (Lightfoot)
   - Human
   - Dragonborn (All Types)
   - Gnome (Rock)
   - Half-Elf
   - Half-Orc
   - Tiefling
2. Classes
   - Barbarian (Path of the Berserker)
   - Bard (College of Lore)
   - Cleric (Life Domain)
   - Druid (Circle of the Land)
   - Fighter (Champion)
   - Monk (Way of the Open Hand)
   - Paladin (Oath of Devotion)
   - ranger (Hunter)
   - Rogue (Thief)
   - Sorcerer (Draconic Bloodlines)
   - Warlock (Pact of the Fiend)
   - Wizard (School of Evocation)

<a name = "howto"/>

## 2. How to use this tool

1. Download the `npc_builder.exe` file.
2. Store the `npc_builder.exe` file in it's own folder somewhere you wont forget about it.
3. Run the program by double clicking.

*Note: Rename the output files to make them distinct. Every time the proram is executed, it will overwrite any files it finds in the directory with the same name. It is the author's recommendation that all files be renamed to include the character's name. This would look something like "Gundren Rockseeker.txt," "Dave the Bard Features.txt," "MarrowMincer.skills," etc.*

<a name = "stepbystep"/>

## 3. What to expect next (a step-by-step guide)

1. A black window will appear with a prompt that reads `Enter your character's name:`
  
2. Enter your character's name.

3. After that, you will be prompted to select your race and class from their respective lists.
   - NOTE: The program will not except "close enough" entries, so make sure you've got it spelled correctly.
  
4. Next, you'll be asked to provide your character's level.

5. Then, you'll be asked to provide the *raw* ability scores for your character.
   - NOTE: You *must* enter them in the order listed.
   - NOTE: The program calculates bonuses based on race, so you don't have do that. In order for your character sheet to be accurate, make sure you aren't accidentally entering the final score.

6. Next up is your health.
   - NOTE: You must enter the total value for this. I haven't gotten this to automatically add/reduce your CON modifier, so that's up to you.
   
7. The last thing you need to do is choose your proficiencies. These will be provided based on your class, so you don't have to worry about making sure you've got an accurate listing.

8. When you're all done entering your character's information, you'll see a basic version of the character sheet right there.

9. Once the program is completed, head to the folder you stored it in and you'll find 4 files with various information:
   - **Character.txt** will store the basic character sheet shown at the end of the program.
   - **CombatReference.txt** will provide a basic formula for calculating damage with STR and DEX based weappons, your spellcasting save DC and spell attack modifier (if applicable), and a list of your attack bonus and damage for every single weapon found in the standard rules.
   - **Features.txt** will store your characters features. These are based on their race and class and level.
   - **Skills.txt** will store your skills and their modifiers. This comes with a box [ ] that is not filled if you are not proficient in that particular skill or a box [x] that is filled if you are.

**Important:**
_In order to ensure you do not lose a character sheet, make sure you rename the file. Every time you run the program, it will overwrite any pre-existing file of the same name **without warning!**_

<a name = "misc"/>
## 4. Misc.

Check out the `Example Output` folder for pictures of the program's output and the user interface. The program should be pretty straightforward, that being said.

I will also update the `README.md` with a list of tasks I still want to complete in order to get this program to it's final stages. It's by no means complete, I just ran out of time to work on it and didn't have the energy to finish what I started when I got the free time back. The tool was written using Ada '95, so feel free to contribute if you want. I'm also interested in making a variation of the tool using Python or Java so I can implement a GUI, but I haven't found time to convert the code.

<a name = "onyourown"/>

## 5. Compiling and building the code on your own

This project was written using Ada '95 (as I'm sure you've gathered by now) so you will need a compiler built for Ada '95. I'm not sure what other compilers are out there, [but I use GNAT on windows](https://sourceforge.net/projects/gnuada/files/GNAT_P%20WinNT%20i386/3.15/). The code editor I'm most familiar with (and good for beginners) is AdaGide, [which can be downloaded here](https://sourceforge.net/projects/adagide/). Download the compiler before downloading the editor.

Once you've got everything downloaded, write your Ada code into Adagide, save the file with the .adb extension, hit compile, then build, then run.

Compiling, Building, and Running from the command line:

Make sure you're in the directory with the .adb file, otherwise this won't work.
* Compile
```
    $ gcc -c name.adb
```
* Build
```
    $ gnatbind name
    $ gnatlink name
```
* Run
   
```
    $ name.exe
```
* If you want to do all of these steps in one go you can write
   
```
    $ gnatmake name.adb
    $ name.exe
```

If you want more resources to help use/learn Ada '95, [check out this website](http://archive.adaic.com/ASE/ase02_01/bookcase/ada_sh/lrm95/RM-TOC.html). I always reference it if I ever need anything Ada-related. It's very thourough and even provides example code so you can see syntax and style.
  
<a name = "contributing"/>

## 6. Looking to contribute to the project?
  
If you want to contribute to this code, you must make sure all content submitted follows the Systems Reference Document (SRD) provided by Wizards of the Coast. No code will be accepted if it includes material outside of the SRD. [The SRD can be found here](http://dnd.wizards.com/articles/features/systems-reference-document-srd).

#### What can you contribute?

If you're looking for ideas on what content you can contribute to this project, go no further. The following is a list of features that I would like to implement, but haven't gotten around to.

1. Spell slots
   * Display spell slots based on class and level.
   * Lv 7 Wizard example
   
   Level | Cantrips | 1st | 2nd | 3rd | 4th 
   ------|----------|-----|-----|-----|-----
   1 | 3 | 2 | - | - | - 
   2 | 3 | 3 | - | - | - 
   3 | 3 | 4 | 2 | - | - 
   4 | 4 | 4 | 3 | - | - 
   5 | 4 | 4 | 3 | 2 | - 
   6 | 4 | 4 | 3 | 3 | - 
   7 | 4 | 4 | 3 | 3 | 1 
   
2. Spell lists
   * Output a spell sheet to Spells.txt.
   * The spells will be displayed based on class.
   * Each spell will have a box next to it to designate it as prepared or not.
   * The spell list will be broken up alphabetically based on level.
   * Haven't decided if I want the list to include all spells available to the class or just those the character knows.
      * If the list includes all spells, there will be another box to designate which spells are known.
3. Apply Acolyte background to the character
   * The Acolyte is the only background available in the SRD, so it should be applied to every character created.
   * This will mess with proficiencies, since it automatically gives the character Insight and Religion proficiencies. The user should be able to choose any other proficiencies in their list on top of those two.
4. Data validation loop for health input
   * This will calculate a max and a min health based on the character's level, class, and CON score. The min and max health values will then be used to restrict user health input. This way, there will be no chance of a level 3 Wizard having 803 HP.
5. Modularize the code
   * It would be really cool to see this program broken up into multiple files. The code is currently broken up into relevant procedures and functions, but it could be broken up even more.
6. Random values
   * Stats can be randomly generated
   * Health can be randomly generated (dependent upon the health data validation loop being implemented)
   * Level can be randomly generated
      * In case someone finds that useful
   * Race, class, proficiencies can be randomly generated
      * These are all enumerated data types, so it wouldn't be too hard to implement.
7. Graphical User Interface (GUI)
   * One of my dreams for this project is to implement a GUI. Unfortunately, I haven't had nearly as much time to allocate to this project as I wanted, so I haven't gotten around to implementing a GUI. There are some really adorably old-school GUIs that can be implemented in Ada '95 code.
8. Java version
   * My next step is implementing this program using Java.
