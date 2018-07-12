# 5eCharacterCreator

**Important:**
*For optimal use of this program, make sure you create a folder to store the npc_builder.exe file in. Upon close, the program creates three files and will store them wherever your original npc_builder.exe file is. In order to save some headache, just create a folder for your stuff. I promise you'll thank me later.*

**Note:**
*I just realized that I was looking at the wrong content for standard rules, so there is a lot of missing content. I'll try to work on expanding the arsenal when I can! Sorry about that!*

This is a tool that will allow you to go through character creation for a Fifth Edition Dungeons and Dragons character. The original purpose of this tool was to provide DMs with a means of character creation that doesn't take an hour and constant flipping between pages.

## 1. Content Currently Available

1. Races
   - Dwarf
   - Elf
   - Halfling
   - Human
2. Classes
   - Cleric
   - Fighter
   - Rogue
   - Wizard
   
I will add more content as my free time allows!

## 2. How to use this tool

1. Download the `npc_builder.exe` file.
2. Store the `npc_builder.exe` file in it's own folder somewhere you wont forget about it.
3. Run the program by double clicking.

## 3. What to expect next (a step-by-step guide)

1. A black window will appear with a prompt that reads `Enter your character's name:`
  
2. Enter your character's name.

3. After that, you will be prompted to select your race, subrace, and class from their respective lists.
   - NOTE: The program will not except "close enough" entries, so make sure you've got it spelled correctly.
  
4. Next, you'll be asked to provide your character's level.

5. Then, you'll be asked to provide the *raw* ability scores for your character.
   - NOTE: You *must* enter them in the order listed.
   - NOTE: The program calculates bonuses based on race/class, so you don't have do that. In order for your character sheet to be accurate, make sure you aren't accidentally entering the final score.

6. Next up is your health.
   - NOTE: You must enter the total value for this. I haven't gotten this to automatically add/reduce your CON modifier, so that's up to you.
   
7. The last thing you get to do is choose your proficiencies. These will be provided based on your class, so you don't have to worry about making sure you've got an accurate listing.

8. When you're all done entering your character's information, you'll see a basic version of the character sheet right there.

9. Once the program is completed, head to the folder you stored it in and you'll find 3 files with various information:
   - **Character.txt** will store the basic character sheet shown at the end of the program.
   - **CombatReference.txt** will provide a basic formula for calculating damage with STR and DEX based weappons, your spellcasting save DC and spell attack modifier (if applicable), and a list of your attack bonus and damage for every single weapon found in the standard rules.
   - **Skills.txt** will store your skills and their modifiers. This comes with a box [ ] that is not filled if you are not proficient in that particular skill or a box [x] that is filled if you are.

**Important:**
_In order to ensure you do not lose a character sheet, make sure your rename the file. Every time you run the program, it will overwrite and pre-existing file of the same name **without warning!**_

## 4. Misc.

Check out the `Example Output` folder for pictures of the program's output and the user interface. The program should be pretty straightforward, that being said.

I will also update the `README.md` with a list of tasks I still want to complete in order to get this program to it's final stages. It's by no means complete, I just ran out of time to work on it and didn't have the energy to finish what I started when I got the free time back. The tool was written using Ada '95, so feel free to contribute if you want. I'm also interested in making a variation of the tool using Python or Java so I can implement a GUI, but I haven't found time to convert the code.

To Do:
  - Output a file with race and class features.
    - Features.txt
  - Output a file with available spells, if applicable. This file will have a section for known and prepared spells as well.
    - Spells.txt
    - This should end up looking similar to the `Skill.txt` file.
  - Implement a backgrounds feature
