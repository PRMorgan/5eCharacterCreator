-- This is a personal project that was conceived
-- from a lack of really quick Dungeons and
-- Dragons character creation tools.

-- The only content supported in this tool
-- is that which can be found in the
-- Systems Reference Document (SRD)
-- from Wizards of the Coast.

-- Created by Patrick M
-- Start Date: 8 March 2018
-- Major Updates: 24 April 2018
--                14 January 2019
--                7 February 2019

--------------- Support from ---------------
-- Kate A (Beta Tester/Ideas)
-- Rebecca N (Beta Tester/Ideas/Problem Solving)
-- Kim O (Beta Tester)
--------------------------------------------

With Ada.Text_IO; Use Ada.Text_IO;
With Ada.Integer_Text_IO; Use Ada.Integer_Text_IO;

Procedure NPC_Builder is

------------------------------------------------------
-- The purpose of this program is to allow DMs and  --
-- players the ability to create NPCs and PCs,      --
-- respectively, without having to crunch numbers.  --
-- This program will also output the various        --
-- character sheet information in easy-to-read      --
-- text files for future reference and saving.      --
------------------------------------------------------

   Type Class_List is (Barbarian, Bard, Cleric, Druid, Fighter, Monk,
                       Paladin, Ranger, Rogue, Sorcerer, Warlock, Wizard);
   Package Class_IO is new Ada.Text_IO.Enumeration_IO (Class_List);
   Use Class_IO;

   Type Subclass_List is (Berserker, Lore, Life, Land, Champion, OpenHand,
                          Devotion, Hunter, Thief, Draconic, Fiend, Evocation);
   Package Subclass_IO is new Ada.Text_IO.Enumeration_IO (Subclass_List);
   Use Subclass_IO;

   Type Race_List is (Dragonborn, Dwarf, Elf, Gnome, HalfElf, Halfling, HalfOrc, Human, Tiefling);
   Package Race_IO is new Ada.Text_IO.Enumeration_IO (Race_List);
   Use Race_IO;

   Type Subrace_List is (Hill, High, Lightfoot, Rock, None,
                         Calishite, Chondathan, Damaran, Illuskan,
                         Mulan, Rashemi, Shou, Tethyrian, Turami, 
                         Black, Blue, Bronze, Brass, Copper,
                         Gold, Green, Red, Silver, White);
   Package Subrace_IO is new Ada.Text_IO.Enumeration_IO (Subrace_List);
   Use Subrace_IO;

   Type Skills_List is (Acrobatics, Animal_Handling, Arcana, Athletics, Deception, History,
		            Insight, Intimidation, Investigation, Medicine, Nature, Perception,
		            Performance, Persuasion, Religion, Sleight_Of_Hand, Stealth, Survival);
   Package Skills_IO is new Ada.Text_IO.Enumeration_IO (Skills_List);
   Use Skills_IO;

   Type Ability_Scores_List is (STR, DEX, CON, INT, WIS, CHA, NA);
   Package Scores_IO is new Ada.Text_IO.Enumeration_IO (Ability_Scores_List);
   Use Scores_IO;

   Type Weapons_List is (Battleaxe, Blowgun, Club, Dagger, Dart, Flail, Glaive,
                         Greatclub, Greatsword, Halberd, Handaxe, HandCrossbow,
                         HeavyCrossbow, Javelin, Lance, LightCrossbow, LightHammer,
                         Longbow, Longsword, Mace, Maul, Morningstar, Net, Pike,
                         Quarterstaff, Rapier, Scimitar, Shortbow, Shortsword,
                         Sickle, Sling, Spear, Trident, Warhammer, Warpick, Whip);
   Package Weapons_IO is new Ada.Text_IO.Enumeration_IO (Weapons_List);
   Use Weapons_IO;

   Type Weapon_Classification_List is (Simple, Martial);
   Package Weapon_Classification_IO is new Ada.Text_IO.Enumeration_IO (Weapon_Classification_List);
   Use Weapon_Classification_IO;

   Type Proficient_Type is record
      base       : Integer := 0;
      proficient : Boolean := false;
   End Record;

   Type Skills_Type is record
      acrobatics     : Proficient_Type;
      animalHandling : Proficient_Type;
      arcana         : Proficient_Type;
      athletics      : Proficient_Type;
      deception      : Proficient_Type;
      history        : Proficient_Type;
      insight        : Proficient_Type;
      intimidation   : Proficient_Type;
      investigation  : Proficient_Type;
      medicine       : Proficient_Type;
      nature         : Proficient_Type;
      perception     : Proficient_Type;
      performance    : Proficient_Type;
      persuasion     : Proficient_Type;
      religion       : Proficient_Type;
      sleightOfHand  : Proficient_Type;
      stealth        : Proficient_Type;
      survival       : Proficient_Type;
   End Record;

   Type Class_Type is record
      --features    : Features_Array;
      hitDice     : Integer;
      main        : Class_List;
      subclass    : Subclass_List;
      level       : Integer;
      skill       : Skills_Type;
      skillName   : Skills_List;
      proficiency : Integer;
   End record;

   Type Health_Type is record
      current : Integer;
      total   : Integer;
   End record;

   Type Name_Type is record
      name   : String (1..25);
      length : Integer;
   End record;

   Type Race_Type is record
      main    : Race_List;
      subrace : Subrace_List;
      size    : Character;
      speed   : Integer;
   End record;

   Type Weapon_Info is record
      classification : Weapon_Classification_List;
      damageAbility  : Ability_Scores_List;
      die            : Positive;
      name           : String (1..14);
      nameLength     : Positive := 5;
      toHit          : Integer;
      proficient     : Boolean;
   End record;

   Type Weapons_Type is array (Weapons_List) of Weapon_Info;

   Type Ability_Score_Type is record
      base      : Integer;
      modifier  : Integer;
   End record;

   Type Stats_Type is record
      STR : Ability_Score_Type;
      DEX : Ability_Score_Type;
      CON : Ability_Score_Type;
      INT : Ability_Score_Type;
      WIS : Ability_Score_Type;
      CHA : Ability_Score_Type;
   End record;

   Type Combat_Type is record
      STRbased      : Integer;
      DEXbased      : Integer;
      STRproficient : Integer;
      DEXproficient : Integer;
      unarmedAttack : Integer;
      spellDC       : Integer;
      spellAttack   : Integer;
      spellStat     : Ability_Scores_List;
      attack        : Weapons_Type;
   End record;

   Type Character_Type is record
      class   : Class_Type;
      health  : Health_Type;
      name    : Name_Type;
      race    : Race_Type;
      stat    : Stats_Type;
      combat  : Combat_Type;
   End record;

   THIRTY_THREE_DASHES : CONSTANT String := "---------------------------------";
   TABLE_BORDER        : CONSTANT String := "|----|---------------------------------";

--Subprograms
   Procedure getUserInput(character  : out Character_Type) is

      choosingScoreImprovement : Boolean := True;
      levelFlag   : Boolean := True;
      profFlag    : Boolean := True;
      scoresFlag  : Boolean := True;
      subraceFlag : Boolean := True;

   Begin -- getUserInput

      -- Name the character
      Put ("Enter the character's name: ");
      New_Line;
      Put (">>> ");
      Get_Line(character.name.name, character.name.length);
      New_Line;

      -- Select the character's race
      Put ("Choose your character's race from the following list:");
      New_Line;
      Put ("Dragonborn, Dwarf, Elf, Gnome, HalfElf, Halfling, HalfOrc, Human, Tiefling: ");
      --------Data Validation Loop--------
      validRaceLoop:
      Loop
            raceInputBlock:
            begin
                  New_Line;
                  Put (">>> ");
                  Race_IO.Get (character.race.main);
                  exit validRaceLoop;
            exception
                  When Ada.Text_IO.DATA_ERROR =>
                        New_Line;
                        Put ("Dragonborn, Dwarf, Elf, Gnome, HalfElf, Halfling, HalfOrc, Human, Tiefling?");
                        Skip_Line;
            End raceInputBlock;
      End loop validRaceLoop;
      --------Data Validation Loop--------
      New_Line;

      -- Select the character's subrace/nationality/ancestry.
      Case character.race.main is
            -- If the character is a Human, have them choose their nationality.
            When Human => Put ("Choose your character's nationality from the following list:");
                  While subraceFlag Loop
                        New_Line;
                        Put ("Calishite, Chondathan, Damaran, Illuskan, Mulan,");
                        New_Line;
                        Put ("Rashemi, Shou, Tethyrian, or Turami");
                        validHumanLoop: -- Only allow valid human subrace
                        Loop
                              humanInputBlock:
                              begin
                                    New_Line;
                                    Put (">>> ");
                                    Subrace_IO.Get (character.race.subrace);
                                    If character.race.subrace = Calishite Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Chondathan Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Damaran Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Illuskan Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Mulan Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Rashemi Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Shou Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Tethyrian Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Turami Then
                                          subraceFlag := False;
                                    Else
                                          subraceFlag := True;
                                    End If;
                                    exit validHumanLoop;
                              exception
                                    When Ada.Text_IO.DATA_ERROR =>
                                          New_Line;
                                          Put ("Calishite, Chondathan, Damaran, Illuskan, Mulan,");
                                          New_Line;
                                          Put ("Rashemi, Shou, Tethyrian, or Turami");
                                          Skip_Line;
                              End humanInputBlock;
                        End Loop validHumanLoop;
                  End Loop;
            -- If the character is a Dragonborn, have them choose their Draconic Ancestry.
            When Dragonborn => Put ("Choose your dragonborn's ancestry from the following list:");
                  While subraceFlag Loop
                        New_Line;
                        Put ("Black (Acid), Blue (Lightning), Brass (Fire), Bronze (Lightning), Copper (Acid),");
                        New_Line;
                        Put ("Gold (Fire), Green (Poison), Red (Fire), Silver (Cold), White (Cold)");
                        New_Line;
                        Put("Enter only the color.");
                        validDragonbornLoop: -- Only allow valid dragonborn subrace
                        Loop
                              dragonbornInputBlock:
                              begin
                                    New_Line;
                                    Put (">>> ");
                                    Subrace_IO.Get (character.race.subrace);
                                    If character.race.subrace = Black Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Blue Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Brass Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Bronze Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Copper Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Gold Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Green Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Red Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = Silver Then
                                          subraceFlag := False;
                                    Elsif character.race.subrace = White Then
                                          subraceFlag := False;
                                    Else
                                          subraceFlag := True;
                                    End If;
                                    exit validDragonbornLoop;
                              exception
                                    When Ada.Text_IO.DATA_ERROR =>
                                          New_Line;
                                          Put ("Black, Blue, Bronze, Brass, Copper,");
                                          New_Line;
                                          Put ("Gold, Green, Red, Silver, White");
                                          Skip_Line;
                              End dragonbornInputBlock;
                        End Loop validDragonbornLoop;
                  End Loop;

            When others => null;
      End Case;
      New_Line;

      Put ("Choose your character's class from the following list:");
      New_Line;
      Put ("Barbarian, Bard, Cleric, Druid, Fighter, Monk,");
      New_Line;
      Put ("Paladin, Ranger, Rogue, Sorcerer, Warlock, Wizard");
      --------Data Validation Loop--------
      validClassLoop:
      Loop
            classInputBlock:
            begin
                  New_Line;
                  Put (">>> ");
                  Class_IO.Get (character.class.main);
                  Exit validClassLoop;
            exception
                  When Ada.Text_IO.DATA_ERROR =>
                        New_Line;
                        Put ("Barbarian, Bard, Cleric, Druid, Fighter, Monk,");
                        New_Line;
                        Put ("Paladin, Ranger, Rogue, Sorcerer, Warlock, or Wizard?");
                        Skip_Line;
            End classInputBlock;
      End Loop validClassLoop;
      --------Data Validation Loop--------

      -- Set the character's subclass based on their main class
      Case character.class.main is
         When Barbarian => character.class.subclass := Berserker;
         When Bard => character.class.subclass := Lore;
         When Cleric  => character.class.subclass := Life;
         When Druid => character.class.subclass := Land;
         When Fighter => character.class.subclass := Champion;
         When Monk => character.class.subclass := OpenHand;
         When Paladin => character.class.subclass := Devotion;
         When Ranger => character.class.subclass := Hunter;
         When Rogue   => character.class.subclass := Thief;
         When Sorcerer => character.class.subclass := Draconic;
         When Warlock => character.class.subclass := Fiend;
         When Wizard  => character.class.subclass := Evocation;
      End Case;
      New_Line;

      -- Have the user input their character's level.
      -- Levels lesser than or equal to 0 are not valid.
      -- Levels greater than 20 are not valid.
      -- D&D 5th Edition does not have official character support for
      -- levels outside of the valid range.
      While levelFlag Loop
            Put ("Note: Valid level range is 1-20.");
            New_Line;
            Put ("Enter the character's level: ");
            New_Line;
            Put (">>> ");
            Get (character.class.level);
            If character.class.level >= 1 and character.class.level <=20 Then
                  levelFlag := False;
            Else
               levelFlag := True;
            End If;
            Skip_Line;
            New_Line;
      End Loop;

      -- Have the user input their raw ability score rolls.
      -- This program calculates racial bonuses for the user.
      While scoresFlag Loop
            Put ("Note: Valid unmodified score range is 3-18.");
            New_Line;
            Put ("Please enter your unmodified scores, in the following order, and on one line: ");
            New_Line;
            Put ("STR, DEX, CON, INT, WIS, and CHA");
            New_Line;
            Put (">>> ");
            Ada.Integer_Text_IO.Get (character.stat.STR.base);
            Ada.Integer_Text_IO.Get (character.stat.DEX.base);
            Ada.Integer_Text_IO.Get (character.stat.CON.base);
            Ada.Integer_Text_IO.Get (character.stat.INT.base);
            Ada.Integer_Text_IO.Get (character.stat.WIS.base);
            Ada.Integer_Text_IO.Get (character.stat.CHA.base);
            If character.stat.STR.base >= 3 and character.stat.STR.base <= 18 and
                  character.stat.DEX.base >= 3 and character.stat.DEX.base <= 18 and
                  character.stat.CON.base >= 3 and character.stat.CON.base <= 18 and
                  character.stat.INT.base >= 3 and character.stat.INT.base <= 18 and
                  character.stat.WIS.base >= 3 and character.stat.WIS.base <= 18 and
                  character.stat.CHA.base >= 3 and character.stat.CHA.base <= 18 Then
                        scoresFlag := False;
            Else
                  scoresFlag := True;
            End If;
            Skip_Line;
            New_Line;
      End Loop;

      -- Have the user input their character's total health.
      -- No support for auto-calculating based on modifiers.
      Put ("Please enter your character's total health: ");
      New_Line;
      Put (">>> ");
      Get (character.health.total);
      Skip_Line;

   End getUserInput;

------------------------------------------------------------

   Procedure caseClassInfo (character : in out Character_type) is

      numSkillProfs : Integer := 2;
      temp : Skills_List;

   Begin -- caseClassInfo

      -- Assign the character's hit dice based on their class.
      Case character.class.main is
         When Barbarian => character.class.hitDice := 12;
         When Bard => character.class.hitDice := 8;
         When Cleric => character.class.hitDice := 8;
         When Druid => character.class.hitDice := 8;
         When Fighter => character.class.hitDice := 10;
         When Monk => character.class.hitDice := 8;
         When Paladin => character.class.hitDice := 10;
         When Ranger => character.class.hitDice := 10;
         When Rogue => character.class.hitDice := 8;
         When Sorcerer => character.class.hitDice := 6;
         When Warlock => character.class.hitDice := 8;
         When Wizard => character.class.hitDice := 6;
      End Case;

      -- Have the user select their proficiencies.
      Case character.class.main is
            When Barbarian => Put ("You can choose 2 skill proficiencies from the following list:");
                              New_Line;
                              Put ("Animal_Handling, Athletics, Intimidation, Nature, Perception");
                              New_Line;
            When Bard => Put ("You can choose any 3 skill proficiencies. Your options are:");
                              New_Line;
                              Put ("Acrobatics, Animal_Handling, Arcana, Athletics, Deception, History,");
                              New_Line;
                              Put ("Insight, Intimidation, Investigation, Medicine, Nature, Perception,");
                              New_Line;
                              Put ("Performance, Persuasion, Religion, Sleight_of_Hand, Stealth, Survival");
                              New_Line;
                              numSkillProfs := 3;
            When Cleric => Put ("You can choose 2 skill proficiencies from the following list:");
                           New_Line;
                           Put ("History, Insight, Medicine, Persuasion, Religion");
                           New_Line;
            When Druid => Put ("You can choose 2 skill proficiencies from the following list:");
                          New_Line;
                          Put ("Arcana, Animal_Handling, Insight, Medicine, Nature, Perception, Religion, Survival");
                          New_Line;
            When Fighter => Put ("You can choose 2 skill proficiencies from the following list:");
                            New_Line;
                            Put ("Acrobatics, Animal_Handling, Athletics, History,");
                            New_Line;
                            Put ("Insight, Intimidation, Perception, Survival");
                            New_Line;
            When Monk => Put ("You can choose 2 skill proficiencies from the following list:");
                         New_Line;
                         Put ("Acrobatics, Athletics, History, Insight, Religion, Stealth");
                         New_Line;
            When Paladin => Put ("You can choose 2 skill proficiencies from the following list:");
                            New_Line;
                            Put ("Athletics, Insight, Intimidation, Medicine, Persuasion, Religion");
                            New_Line;
            When Ranger => Put ("You can choose 3 skill proficiencies from the following list:");
                           New_Line;
                           Put ("Animal_Handling, Athletics, Deception, Insight, Intimidation,");
                           New_Line;
                           Put ("Investigation, Perception, Persuasion, Sleight_of_Hand, Stealth");
                           New_Line;
                           numSkillProfs := 3;
            When Rogue => Put ("You can choose 4 skill proficiencies from the following list:");
                          New_Line;
                          Put ("Acrobatics, Athletics, Deception, Insight, Intimidation,");
                          New_Line;
                          Put ("Investigation, Perception, Persuasion, Sleight_of_Hand, Stealth");
                          New_Line;
                          numSkillProfs := 4;
            When Sorcerer => Put ("You can choose 2 skill proficiencies from the following list:");
                             New_Line;
                             Put ("Arcana, Deception, Insight, Intimidation, Persuasion, Religion");
                             New_Line;
            When Warlock => Put ("You can choose 2 skill proficiencies from the following list:");
                            New_Line;
                            Put ("Arcana, Deception, History, Intimidation, Investigation, Nature, Religion");
                            New_Line;
            When Wizard => Put ("You can choose 2 skill proficiencies from the following list:");
                           New_Line;
                           Put ("Arcana, History, Insight, Investigation, Medicine, Religion");
                           New_Line;
      End Case;

      -- Bards get 3 proficiencies
      -- Ranger get 3 proficiencies
      -- Rogues get 4 proficiencies
      If character.class.main = Bard Then
            numSkillProfs := 3;
      Elsif character.class.main = Ranger Then
            numSkillProfs := 3;
      Elsif character.class.main = Rogue Then
            numSkillProfs := 4;
      Else
           numSkillProfs := 2;
      End If;

      -- Proficiency selection loop
      For i in 1..numSkillProfs Loop
            Put (i, 1);
            Put (". ");
            Skills_IO.Get (character.class.skillName);
            temp := character.class.skillName;
            Case temp is
                  When Acrobatics => character.class.skill.acrobatics.proficient := True;
                  When Animal_Handling => character.class.skill.animalhandling.proficient := True;
                  When Arcana => character.class.skill.arcana.proficient := True;
                  When Athletics => character.class.skill.athletics.proficient := True;
                  When Deception => character.class.skill.deception.proficient := True;
                  When History => character.class.skill.history.proficient := True;
                  When Insight => character.class.skill.insight.proficient := True;
                  When Intimidation => character.class.skill.intimidation.proficient := True;
                  When Investigation => character.class.skill.investigation.proficient := True;
                  When Medicine => character.class.skill.medicine.proficient := True;
                  When Nature => character.class.skill.nature.proficient := True;
                  When Perception => character.class.skill.perception.proficient := True;
                  When Performance => character.class.skill.performance.proficient := True;
                  When Persuasion => character.class.skill.persuasion.proficient := True;
                  When Religion => character.class.skill.religion.proficient := True;
                  When Sleight_of_Hand => character.class.skill.sleightOfHand.proficient := True;
                  When Stealth => character.class.skill.stealth.proficient := True;
                  When Survival => character.class.skill.survival.proficient := True;
            End Case;
      End Loop;
      Skip_Line;

      -- Add character's proficiency to skills they selected
      ----------
      If character.class.skill.acrobatics.proficient Then
            character.class.skill.acrobatics.base := character.stat.DEX.modifier + character.class.proficiency;
      Else
            character.class.skill.acrobatics.base := character.stat.DEX.modifier;
      End If;
      ----------
      If character.class.skill.animalHandling.proficient Then
            character.class.skill.animalHandling.base := character.stat.WIS.modifier + character.class.proficiency;
      Else
            character.class.skill.animalHandling.base := character.stat.WIS.modifier;
      End If;
      ----------
      If character.class.skill.arcana.proficient Then
            character.class.skill.arcana.base := character.stat.INT.modifier + character.class.proficiency;
      Else
            character.class.skill.arcana.base := character.stat.INT.modifier;
      End If;
      ----------
      If character.class.skill.athletics.proficient Then
            character.class.skill.athletics.base := character.stat.STR.modifier + character.class.proficiency;
      Else
            character.class.skill.athletics.base := character.stat.STR.modifier;
      End If;
      ----------
      If character.class.skill.deception.proficient Then
            character.class.skill.deception.base := character.stat.CHA.modifier + character.class.proficiency;
      Else
            character.class.skill.deception.base := character.stat.CHA.modifier;
      End If;
      ----------
      If character.class.skill.history.proficient Then
            character.class.skill.history.base := character.stat.INT.modifier + character.class.proficiency;
      Else
            character.class.skill.history.base := character.stat.INT.modifier;
      End If;
      ----------
      If character.class.skill.insight.proficient Then
            character.class.skill.insight.base := character.stat.WIS.modifier + character.class.proficiency;
      Else
            character.class.skill.insight.base := character.stat.WIS.modifier;
      End If;
      ----------
      If character.class.skill.intimidation.proficient Then
            character.class.skill.intimidation.base := character.stat.CHA.modifier + character.class.proficiency;
      Else
            character.class.skill.intimidation.base := character.stat.CHA.modifier;
      End If;
      ----------
      If character.class.skill.investigation.proficient Then
            character.class.skill.investigation.base := character.stat.INT.modifier + character.class.proficiency;
      Else
            character.class.skill.investigation.base := character.stat.INT.modifier;
      End If;
      ----------
      If character.class.skill.medicine.proficient Then
            character.class.skill.medicine.base := character.stat.WIS.modifier + character.class.proficiency;
      Else
            character.class.skill.medicine.base := character.stat.WIS.modifier;
      End If;
      ----------
      If character.class.skill.nature.proficient Then
            character.class.skill.nature.base := character.stat.INT.modifier + character.class.proficiency;
      Else
            character.class.skill.nature.base := character.stat.INT.modifier;
      End If;
      ----------
      If character.class.skill.perception.proficient Then
            character.class.skill.perception.base := character.stat.WIS.modifier + character.class.proficiency;
      Else
            character.class.skill.perception.base := character.stat.WIS.modifier;
      End If;
      ----------
      If character.class.skill.performance.proficient Then
            character.class.skill.performance.base := character.stat.CHA.modifier + character.class.proficiency;
      Else
            character.class.skill.performance.base := character.stat.CHA.modifier;
      End If;
      ----------
      If character.class.skill.persuasion.proficient Then
            character.class.skill.persuasion.base := character.stat.CHA.modifier + character.class.proficiency;
      Else
            character.class.skill.persuasion.base := character.stat.CHA.modifier;
      End If;
      ----------
      If character.class.skill.religion.proficient Then
            character.class.skill.religion.base := character.stat.INT.modifier + character.class.proficiency;
      Else
            character.class.skill.religion.base := character.stat.INT.modifier;
      End If;
      ----------
      If character.class.skill.sleightOfHand.proficient Then
            character.class.skill.sleightOfHand.base := character.stat.DEX.modifier + character.class.proficiency;
      Else
            character.class.skill.sleightOfHand.base := character.stat.DEX.modifier;
      End If;
      ----------
      If character.class.skill.stealth.proficient Then
            character.class.skill.stealth.base := character.stat.DEX.modifier + character.class.proficiency;
      Else
            character.class.skill.stealth.base := character.stat.DEX.modifier;
      End If;
      ----------
      If character.class.skill.survival.proficient Then
            character.class.skill.survival.base := character.stat.WIS.modifier + character.class.proficiency;
      Else
            character.class.skill.survival.base := character.stat.WIS.modifier;
      End If;
      ----------

   End caseClassInfo;
   ------------------------------------------------------------

   Procedure caseAbilityScores (character : in out Character_Type) is

   Begin -- caseAbilityScores

      -- Assign modifiers to ability scores
      Case character.stat.STR.base is
         When 1      => character.stat.STR.modifier := -5;
         When 2..3   => character.stat.STR.modifier := -4;
         When 4..5   => character.stat.STR.modifier := -3;
         When 6..7   => character.stat.STR.modifier := -2;
         When 8..9   => character.stat.STR.modifier := -1;
         When 10..11 => character.stat.STR.modifier := 0;
         When 12..13 => character.stat.STR.modifier := 1;
         When 14..15 => character.stat.STR.modifier := 2;
         When 16..17 => character.stat.STR.modifier := 3;
         When 18..19 => character.stat.STR.modifier := 4;
         When 20     => character.stat.STR.modifier := 5;
         When others => character.stat.STR.modifier := -99;
      End Case;
      Case character.stat.DEX.base is
         When 1      => character.stat.DEX.modifier := -5;
         When 2..3   => character.stat.DEX.modifier := -4;
         When 4..5   => character.stat.DEX.modifier := -3;
         When 6..7   => character.stat.DEX.modifier := -2;
         When 8..9   => character.stat.DEX.modifier := -1;
         When 10..11 => character.stat.DEX.modifier := 0;
         When 12..13 => character.stat.DEX.modifier := 1;
         When 14..15 => character.stat.DEX.modifier := 2;
         When 16..17 => character.stat.DEX.modifier := 3;
         When 18..19 => character.stat.DEX.modifier := 4;
         When 20     => character.stat.DEX.modifier := 5;
         When others => character.stat.DEX.modifier := -99;
      End Case;
      Case character.stat.CON.base is
         When 1      => character.stat.CON.modifier := -5;
         When 2..3   => character.stat.CON.modifier := -4;
         When 4..5   => character.stat.CON.modifier := -3;
         When 6..7   => character.stat.CON.modifier := -2;
         When 8..9   => character.stat.CON.modifier := -1;
         When 10..11 => character.stat.CON.modifier := 0;
         When 12..13 => character.stat.CON.modifier := 1;
         When 14..15 => character.stat.CON.modifier := 2;
         When 16..17 => character.stat.CON.modifier := 3;
         When 18..19 => character.stat.CON.modifier := 4;
         When 20     => character.stat.CON.modifier := 5;
         When others => character.stat.CON.modifier := -99;
      End Case;
      Case character.stat.INT.base is
         When 1      => character.stat.INT.modifier := -5;
         When 2..3   => character.stat.INT.modifier := -4;
         When 4..5   => character.stat.INT.modifier := -3;
         When 6..7   => character.stat.INT.modifier := -2;
         When 8..9   => character.stat.INT.modifier := -1;
         When 10..11 => character.stat.INT.modifier := 0;
         When 12..13 => character.stat.INT.modifier := 1;
         When 14..15 => character.stat.INT.modifier := 2;
         When 16..17 => character.stat.INT.modifier := 3;
         When 18..19 => character.stat.INT.modifier := 4;
         When 20     => character.stat.INT.modifier := 5;
         When others => character.stat.INT.modifier := -99;
      End Case;
      Case character.stat.WIS.base is
         When 1      => character.stat.WIS.modifier := -5;
         When 2..3   => character.stat.WIS.modifier := -4;
         When 4..5   => character.stat.WIS.modifier := -3;
         When 6..7   => character.stat.WIS.modifier := -2;
         When 8..9   => character.stat.WIS.modifier := -1;
         When 10..11 => character.stat.WIS.modifier := 0;
         When 12..13 => character.stat.WIS.modifier := 1;
         When 14..15 => character.stat.WIS.modifier := 2;
         When 16..17 => character.stat.WIS.modifier := 3;
         When 18..19 => character.stat.WIS.modifier := 4;
         When 20     => character.stat.WIS.modifier := 5;
         When others => character.stat.WIS.modifier := -99;
      End Case;
      Case character.stat.CHA.base is
         When 1      => character.stat.CHA.modifier := -5;
         When 2..3   => character.stat.CHA.modifier := -4;
         When 4..5   => character.stat.CHA.modifier := -3;
         When 6..7   => character.stat.CHA.modifier := -2;
         When 8..9   => character.stat.CHA.modifier := -1;
         When 10..11 => character.stat.CHA.modifier := 0;
         When 12..13 => character.stat.CHA.modifier := 1;
         When 14..15 => character.stat.CHA.modifier := 2;
         When 16..17 => character.stat.CHA.modifier := 3;
         When 18..19 => character.stat.CHA.modifier := 4;
         When 20     => character.stat.CHA.modifier := 5;
         When others => character.stat.CHA.modifier := -99;
      End Case;

      -- Assign the character's proficiency based on their level
      Case character.class.level is
         When 0..4   => character.class.proficiency := 2;
         When 5..8   => character.class.proficiency := 3;
         When 9..12  => character.class.proficiency := 4;
         When 13..16 => character.class.proficiency := 5;
         When 17..20 => character.class.proficiency := 6;
         When others => character.class.proficiency := 0;
      End Case;
   End caseAbilityScores;

------------------------------------------------------------

   Procedure caseRaceInfo (character : in out Character_Type) is

   Begin --caseRaceInfo

      -- Assign speed, size, and ability score
      -- increases based on the character's race.
      Case character.race.main is
         When Dragonborn => character.race.speed := 30;
                            character.race.size := 'M';
                            character.stat.STR.base := character.stat.STR.base +2;
                            character.stat.CHA.base := character.stat.CHA.base +1;
         When Dwarf      => character.race.speed := 25;
                            character.race.size := 'M';
                            character.stat.CON.base := character.stat.CON.base +2;
                            character.race.subrace := Hill;
         When Elf        => character.race.speed := 30;
                            If character.race.subrace = High Then
                                character.race.speed := 35;
                            End if;
                            character.race.size := 'M';
                            character.stat.DEX.base := character.stat.DEX.base +2;
                            character.race.subrace := High;
         When Gnome      => character.race.speed := 25;
                            character.race.size := 'S';
                            character.stat.INT.base := character.stat.INT.base +2;
                            character.race.subrace := Rock;
         When Halfling   => character.race.speed := 25;
                            character.race.size := 'S';
                            character.stat.DEX.base := character.stat.DEX.base +2;
                            character.race.subrace := Lightfoot;
         When Human      => character.race.speed := 30;
                            character.race.size := 'M';
                            character.stat.STR.base := character.stat.STR.base +1;
                            character.stat.DEX.base := character.stat.DEX.base +1;
                            character.stat.CON.base := character.stat.CON.base +1;
                            character.stat.INT.base := character.stat.INT.base +1;
                            character.stat.WIS.base := character.stat.WIS.base +1;
                            character.stat.CHA.base := character.stat.CHA.base +1;
         When HalfElf    => character.race.speed := 30;
                            character.race.size := 'M';
                            character.stat.CHA.base := character.stat.CHA.base +2;
                            character.race.subrace := None;
         When HalfOrc    => character.race.speed := 30;
                            character.race.size := 'M';
                            character.stat.STR.base := character.stat.STR.base +2;
                            character.stat.CON.base := character.stat.CON.base +1;
                            character.race.subrace := None;
         When Tiefling   => character.race.speed := 30;
                            character.race.size := 'M';
                            character.stat.CHA.base := character.stat.CHA.base +2;
                            character.stat.INT.base := character.stat.INT.base +1;
                            character.race.subrace := None;
         When others => null;
      End Case;

      -- Assign ability score increases based on the character's subrace
      Case character.race.subrace is
         When Hill      => character.stat.WIS.base := character.stat.WIS.base +1;
         When High      => character.stat.INT.base := character.stat.INT.base +1;
         When Lightfoot => character.stat.CHA.base := character.stat.CHA.base +1;
         When Rock      => character.stat.CON.base := character.stat.CON.base +1;
         When others    => null;
      End Case;

   End caseRaceInfo;

------------------------------------------------------------

   Procedure halfElfAbilities (character : in out Character_Type) is

      --------------------Identifiers--------------------
      -- num_modified : An integer to keep track of
      --                how many scores have been changed.
      -- stat_temp : A variable that represents which
      --             stat is being modified.
      ---------------------------------------------------

      num_modified : Integer := 0;
      stat_temp : String(1..3);

   Begin -- halfElfAbilities

      -- If the character is a Half Elf, the user can assign
      -- 2 ability score increases and they see fit.
      Put ("You have chosen Half-Elf as your race. One of your racial traits");
      New_Line;
      Put ("allows you to increase your ability scores.");
      New_Line;
      Put ("You have 2 points to allocate where you desire. Your score cannot");
      New_Line;
      Put ("exceed 20. Your current stats are:");
      New_Line;
      -- Output the character's stats to the screen
      -- so the user can see what they already have.
      Put (THIRTY_THREE_DASHES);
      New_Line;
      Set_Col(1);
      Put ("STR");
      Set_Col(7);
      Put ("DEX");
      Set_Col(13);
      Put ("CON");
      Set_Col(19);
      Put ("INT");
      Set_Col(25);
      Put ("WIS");
      Set_Col(31);
      Put ("CHA");
      New_Line;
      Put (THIRTY_THREE_DASHES);
      New_Line;
      Set_Col(1+1);
      Put (character.stat.STR.base, 1);
      Set_Col(7+1);
      Put (character.stat.DEX.base, 1);
      Set_Col(13+1);
      Put (character.stat.CON.base, 1);
      Set_Col(19+1);
      Put (character.stat.INT.base, 1);
      Set_Col(25+1);
      Put (character.stat.WIS.base, 1);
      Set_Col(31+1);
      Put (character.stat.CHA.base, 1);
      New_Line;
      Set_Col(1);
      Put("(");
      If character.stat.STR.modifier >= 0 Then
      Put("+");
      Put(character.stat.STR.modifier, 1);
      Else
      Put(character.stat.STR.modifier, 1);
      End If;
      Put(")");
      Set_Col(7);
      Put("(");
      If character.stat.DEX.modifier >= 0 Then
      Put("+");
      Put(character.stat.DEX.modifier, 1);
      Else
      Put(character.stat.DEX.modifier, 1);
      End If;
      Put(")");
      Set_Col(13);
      Put("(");
      If character.stat.CON.modifier >= 0 Then
      Put("+");
      Put(character.stat.CON.modifier, 1);
      Else
      Put(character.stat.CON.modifier, 1);
      End If;
      Put(")");
      Set_Col(19);
      Put("(");
      If character.stat.INT.modifier >= 0 Then
      Put("+");
      Put(character.stat.INT.modifier, 1);
      Else
      Put(character.stat.INT.modifier, 1);
      End If;
      Put(")");
      Set_Col(25);
      Put("(");
      If character.stat.WIS.modifier >= 0 Then
      Put("+");
      Put(character.stat.WIS.modifier, 1);
      Else
      Put(character.stat.WIS.modifier, 1);
      End If;
      Put(")");
      Set_Col(31);
      Put("(");
      If character.stat.CHA.modifier >= 0 Then
      Put("+");
      Put(character.stat.CHA.modifier, 1);
      Else
      Put(character.stat.CHA.modifier, 1);
      End If;
      Put(")");
      New_Line;
      Put (THIRTY_THREE_DASHES);
      New_Line(2);

      -- Have the user select the stat(s) they would like to increase.
      Put ("Enter the 3 letter abbreviation that corresponds to the");
      New_Line;
      Put ("ability score you would like to increase, one at a time:");
      New_Line;
      While (num_modified < 2) Loop
            Put (">>> ");
            Get(stat_temp);
            If stat_temp = "STR" and character.stat.STR.base < 20 Then
                  character.stat.STR.base := character.stat.STR.base + 1;
                  num_modified := num_modified + 1;
            Elsif stat_temp = "DEX" and character.stat.DEX.base < 20 Then
                  character.stat.DEX.base := character.stat.DEX.base + 1;
                  num_modified := num_modified + 1;
            Elsif stat_temp = "CON" and character.stat.CON.base < 20 Then
                  character.stat.CON.base := character.stat.CON.base + 1;
                  num_modified := num_modified + 1;
            Elsif stat_temp = "INT" and character.stat.INT.base < 20 Then
                  character.stat.INT.base := character.stat.INT.base + 1;
                  num_modified := num_modified + 1;
            Elsif stat_temp = "WIS" and character.stat.WIS.base < 20 Then
                  character.stat.WIS.base := character.stat.WIS.base + 1;
                  num_modified := num_modified + 1;
            Elsif stat_temp = "CHA" and character.stat.CHA.base < 20 Then
                  character.stat.CHA.base := character.stat.CHA.base + 1;
                  num_modified := num_modified + 1;
            Else
                  Put ("Invalid selection. Please check you've entered a valid stat.");
            End If;
            New_Line;
            Exit When num_modified = 2;
      End Loop;

   End halfElfAbilities;

------------------------------------------------------------

   Procedure combatReference (character : in out Character_Type) is

      spellDCBase : Integer;

   Begin --combatReference

      -- Physical combat information
      -- Compute the attack modifer, based on the weapon's ability score
      -- and the character's proficiency with that weapon.
      character.combat.STRbased := character.stat.STR.modifier;
      character.combat.STRproficient :=
            character.stat.STR.modifier + character.class.proficiency;

      character.combat.DEXbased := character.stat.DEX.modifier;
      character.combat.DEXproficient :=
            character.stat.DEX.modifier + character.class.proficiency;

      character.combat.unarmedAttack :=
            character.stat.STR.modifier + character.class.proficiency;

      -- Spellcasting Information
      -- Calculate the Spell Save DC, Spell Attack Modifier, and
      -- set the Spellcasting Ability Score.
      spellDCBase := 8 + character.class.proficiency;
      Case character.class.main is
            When Bard => character.combat.spellDC :=
                              spellDCBase + character.stat.CHA.modifier;
                         character.combat.spellAttack :=
                              character.class.proficiency + character.stat.CHA.modifier;
                         character.combat.spellStat := CHA;
            When Cleric => character.combat.spellDC :=
                              spellDCBase + character.stat.WIS.modifier;
                           character.combat.spellAttack :=
                              character.class.proficiency + character.stat.WIS.modifier;
                           character.combat.spellStat := WIS;
            When Druid => character.combat.spellDC :=
                              spellDCBase + character.stat.WIS.modifier;
                         character.combat.spellAttack :=
                              character.class.proficiency + character.stat.WIS.modifier;
                         character.combat.spellStat := WIS;
            -- Monks are not spellcasters. In this case,
            -- spellDC refers to the Monk's Ki Save DC.
            When Monk => character.combat.spellDC := 
                              spellDCBase + character.stat.WIS.modifier;
                         character.combat.spellAttack := -99;
                         character.combat.spellStat := NA;
            When Paladin => character.combat.spellDC :=
                              spellDCBase + character.stat.CHA.modifier;
                         character.combat.spellAttack :=
                              character.class.proficiency + character.stat.CHA.modifier;
                         character.combat.spellStat := CHA;
            When Ranger => character.combat.spellDC :=
                              spellDCBase + character.stat.WIS.modifier;
                         character.combat.spellAttack :=
                              character.class.proficiency + character.stat.WIS.modifier;
                         character.combat.spellStat := WIS;
            When Sorcerer => character.combat.spellDC :=
                              spellDCBase + character.stat.CHA.modifier;
                         character.combat.spellAttack :=
                              character.class.proficiency + character.stat.CHA.modifier;
                         character.combat.spellStat := CHA;
            When Warlock => character.combat.spellDC :=
                              spellDCBase + character.stat.CHA.modifier;
                         character.combat.spellAttack :=
                              character.class.proficiency + character.stat.CHA.modifier;
                         character.combat.spellStat := CHA;
            When Wizard => character.combat.spellDC :=
                              spellDCBase + character.stat.INT.modifier;
                           character.combat.spellAttack :=
                              character.class.proficiency + character.stat.INT.modifier;
                           character.combat.spellStat := INT;
            -- Non-Spellcasters get their scores set to an arbitrary
            -- value because they don't have a Spell Save DC,
            -- Spell Attack Modifier, or a Spellcasting Ability Score.
            -- These values are set in the rare event that a
            -- non-spellcasting class gets classified as spellcasting.
            When others => character.combat.spellDC := -99;
                           character.combat.spellAttack := -99;
                           character.combat.spellStat := NA;
      End Case;

      -- Hard Coded:
      --     Damage Die
      --     Classification (simple/martial)
      --     Damage Ability Score
      --     Name string
      --     Name length integer
      character.combat.attack(Battleaxe).die := 8;
      character.combat.attack(Battleaxe).classification := Martial;
      character.combat.attack(Battleaxe).damageAbility := STR;
      character.combat.attack(Battleaxe).name := "Battleaxe     ";
      character.combat.attack(Battleaxe).nameLength := 9;
      ---
      character.combat.attack(Blowgun).die := 1;
      character.combat.attack(Blowgun).classification := Martial;
      character.combat.attack(Blowgun).damageAbility := DEX;
      character.combat.attack(Blowgun).name := "Blowgun       ";
      character.combat.attack(Blowgun).nameLength := 7;
      ---
      character.combat.attack(Club).die := 4;
      character.combat.attack(Club).classification := Simple;
      character.combat.attack(Club).damageAbility := STR;
      character.combat.attack(Club).name := "Club          ";
      character.combat.attack(Club).nameLength := 4;
      ---
      character.combat.attack(Dagger).die := 4;
      character.combat.attack(Dagger).classification := Simple;
      character.combat.attack(Dagger).damageAbility := STR;
      character.combat.attack(Dagger).name := "Dagger        ";
      character.combat.attack(Dagger).nameLength := 6;
      ---
      character.combat.attack(Dart).die := 4;
      character.combat.attack(Dart).classification := Simple;
      character.combat.attack(Dart).damageAbility := DEX;
      character.combat.attack(Dart).name := "Dart          ";
      character.combat.attack(Dart).nameLength := 4;
      ---
      character.combat.attack(Flail).die := 8;
      character.combat.attack(Flail).classification := Martial;
      character.combat.attack(Flail).damageAbility := STR;
      character.combat.attack(Flail).name := "Flail         ";
      character.combat.attack(Flail).nameLength := 5;
      ---
      character.combat.attack(Glaive).die := 10;
      character.combat.attack(Glaive).classification := Martial;
      character.combat.attack(Glaive).damageAbility := STR;
      character.combat.attack(Glaive).name := "Glaive        ";
      character.combat.attack(Glaive).nameLength := 6;
      ---
      character.combat.attack(Greatclub).die := 8;
      character.combat.attack(Greatclub).classification := Simple;
      character.combat.attack(Greatclub).damageAbility := STR;
      character.combat.attack(Greatclub).name := "Greatclub     ";
      character.combat.attack(Greatclub).nameLength := 9;
      ---
      character.combat.attack(Greatsword).die := 6;
      character.combat.attack(Greatsword).classification := Martial;
      character.combat.attack(Greatsword).damageAbility := STR;
      character.combat.attack(Greatsword).name := "Greatsword    ";
      character.combat.attack(Greatsword).nameLength := 10;
      ---
      character.combat.attack(Halberd).die := 10;
      character.combat.attack(Halberd).classification := Martial;
      character.combat.attack(Halberd).damageAbility := STR;
      character.combat.attack(Halberd).name := "Halberd       ";
      character.combat.attack(Halberd).nameLength := 7;
      ---
      character.combat.attack(Handaxe).die := 6;
      character.combat.attack(Handaxe).classification := Simple;
      character.combat.attack(Handaxe).damageAbility := STR;
      character.combat.attack(Handaxe).name := "Handaxe       ";
      character.combat.attack(Handaxe).nameLength := 7;
      ---
      character.combat.attack(HandCrossbow).die := 6;
      character.combat.attack(HandCrossbow).classification := Martial;
      character.combat.attack(HandCrossbow).damageAbility := DEX;
      character.combat.attack(HandCrossbow).name := "Hand Crossbow ";
      character.combat.attack(HandCrossbow).nameLength := 13;
      ---
      character.combat.attack(HeavyCrossbow).die := 10;
      character.combat.attack(HeavyCrossbow).classification := Martial;
      character.combat.attack(HeavyCrossbow).damageAbility := DEX;
      character.combat.attack(HeavyCrossbow).name := "Heavy Crossbow";
      character.combat.attack(HeavyCrossbow).nameLength := 14;
      ---
      character.combat.attack(Javelin).die := 6;
      character.combat.attack(Javelin).classification := Simple;
      character.combat.attack(Javelin).damageAbility := STR;
      character.combat.attack(Javelin).name := "Javelin       ";
      character.combat.attack(Javelin).nameLength := 7;
      ---
      character.combat.attack(Lance).die := 12;
      character.combat.attack(Lance).classification := Martial;
      character.combat.attack(Lance).damageAbility := STR;
      character.combat.attack(Lance).name := "Lance         ";
      character.combat.attack(Lance).nameLength := 5;
      ---
      character.combat.attack(LightCrossbow).die := 8;
      character.combat.attack(LightCrossbow).classification := Simple;
      character.combat.attack(LightCrossbow).damageAbility := DEX;
      character.combat.attack(LightCrossbow).name := "Light Crossbow";
      character.combat.attack(LightCrossbow).nameLength := 14;
      ---
      character.combat.attack(LightHammer).die := 4;
      character.combat.attack(LightHammer).classification := Simple;
      character.combat.attack(LightHammer).damageAbility := STR;
      character.combat.attack(LightHammer).name := "Light Hammer  ";
      character.combat.attack(LightHammer).nameLength := 12;
      ---
      character.combat.attack(Longbow).die := 8;
      character.combat.attack(Longbow).classification := Martial;
      character.combat.attack(Longbow).damageAbility := DEX;
      character.combat.attack(Longbow).name := "Longbow       ";
      character.combat.attack(Longbow).nameLength := 7;
      ---
      character.combat.attack(Longsword).die := 8;
      character.combat.attack(Longsword).classification := Martial;
      character.combat.attack(Longsword).damageAbility := STR;
      character.combat.attack(Longsword).name := "Longsword     ";
      character.combat.attack(Longsword).nameLength := 9;
      ---
      character.combat.attack(Mace).die := 6;
      character.combat.attack(Mace).classification := Simple;
      character.combat.attack(Mace).damageAbility := STR;
      character.combat.attack(Mace).name := "Mace          ";
      character.combat.attack(Mace).nameLength := 4;
      ---
      character.combat.attack(Maul).die := 6;
      character.combat.attack(Maul).classification := Martial;
      character.combat.attack(Maul).damageAbility := STR;
      character.combat.attack(Maul).name := "Maul          ";
      character.combat.attack(Maul).nameLength := 4;
      ---
      character.combat.attack(Morningstar).die := 8;
      character.combat.attack(Morningstar).classification := Martial;
      character.combat.attack(Morningstar).damageAbility := STR;
      character.combat.attack(Morningstar).name := "Morningstar   ";
      character.combat.attack(Morningstar).nameLength := 11;
      ---
      character.combat.attack(Net).die := 99;
      character.combat.attack(Net).classification := Martial;
      character.combat.attack(Net).damageAbility := DEX;
      character.combat.attack(Net).name := "Net           ";
      character.combat.attack(Net).nameLength := 3;
      ---
      character.combat.attack(Pike).die := 10;
      character.combat.attack(Pike).classification := Martial;
      character.combat.attack(Pike).damageAbility := STR;
      character.combat.attack(Pike).name := "Pike          ";
      character.combat.attack(Pike).nameLength := 4;
      ---
      character.combat.attack(Quarterstaff).die := 6;
      character.combat.attack(Quarterstaff).classification := Simple;
      character.combat.attack(Quarterstaff).damageAbility := STR;
      character.combat.attack(Quarterstaff).name := "Quarterstaff  ";
      character.combat.attack(Quarterstaff).nameLength := 12;
      ---
      character.combat.attack(Rapier).die := 8;
      character.combat.attack(Rapier).classification := Martial;
      character.combat.attack(Rapier).damageAbility := STR;
      character.combat.attack(Rapier).name := "Rapier        ";
      character.combat.attack(Rapier).nameLength := 6;
      ---
      character.combat.attack(Scimitar).die := 6;
      character.combat.attack(Scimitar).classification := Martial;
      character.combat.attack(Scimitar).damageAbility := STR;
      character.combat.attack(Scimitar).name := "Scimitar      ";
      character.combat.attack(Scimitar).nameLength := 8;
      ---
      character.combat.attack(Shortbow).die := 6;
      character.combat.attack(Shortbow).classification := Simple;
      character.combat.attack(Shortbow).damageAbility := DEX;
      character.combat.attack(Shortbow).name := "Shortbow      ";
      character.combat.attack(Shortbow).nameLength := 8;
      ---
      character.combat.attack(Shortsword).die := 6;
      character.combat.attack(Shortsword).classification := Martial;
      character.combat.attack(Shortsword).damageAbility := STR;
      character.combat.attack(Shortsword).name := "Shortsword    ";
      character.combat.attack(Shortsword).nameLength := 10;
      ---
      character.combat.attack(Sickle).die := 4;
      character.combat.attack(Sickle).classification := Simple;
      character.combat.attack(Sickle).damageAbility := STR;
      character.combat.attack(Sickle).name := "Sickle        ";
      character.combat.attack(Sickle).nameLength := 6;
      ---
      character.combat.attack(Sling).die := 4;
      character.combat.attack(Sling).classification := Simple;
      character.combat.attack(Sling).damageAbility := DEX;
      character.combat.attack(Sling).name := "Sling         ";
      character.combat.attack(Sling).nameLength := 5;
      ---
      character.combat.attack(Spear).die := 6;
      character.combat.attack(Spear).classification := Simple;
      character.combat.attack(Spear).damageAbility := STR;
      character.combat.attack(Spear).name := "Spear         ";
      character.combat.attack(Spear).nameLength := 5;
      ---
      character.combat.attack(Trident).die := 6;
      character.combat.attack(Trident).classification := Martial;
      character.combat.attack(Trident).damageAbility := STR;
      character.combat.attack(Trident).name := "Trident       ";
      character.combat.attack(Trident).nameLength := 7;
      ---
      character.combat.attack(Warhammer).die := 8;
      character.combat.attack(Warhammer).classification := Martial;
      character.combat.attack(Warhammer).damageAbility := STR;
      character.combat.attack(Warhammer).name := "Warhammer     ";
      character.combat.attack(Warhammer).nameLength := 9;
      ---
      character.combat.attack(Warpick).die := 8;
      character.combat.attack(Warpick).classification := Martial;
      character.combat.attack(Warpick).damageAbility := STR;
      character.combat.attack(Warpick).name := "Warpick       ";
      character.combat.attack(Warpick).nameLength := 7;
      ---
      character.combat.attack(Whip).die := 4;
      character.combat.attack(Whip).classification := Martial;
      character.combat.attack(Whip).damageAbility := STR;
      character.combat.attack(Whip).name := "Whip          ";
      character.combat.attack(Whip).nameLength := 4;

      --Assign weapon proficiencies based on class
      For i in character.combat.attack'range Loop
            ---
            If character.class.main = Barbarian Then
                  character.combat.attack(i).proficient := True;
                  --If character.combat.attack(i).classification = Simple Then
                  --     character.combat.attack(i).proficient := True;
                  --Else
                  --     character.combat.attack(i).proficient := True;
                  --End If;
            ---
            Elsif character.class.main = Bard Then
                  If character.combat.attack(i).classification = Simple Then
                        character.combat.attack(i).proficient := True;
                  Else
                        character.combat.attack(i).proficient := False;
                  End If;
                  character.combat.attack(HandCrossbow).proficient := True;
                  character.combat.attack(Longsword).proficient := True;
                  character.combat.attack(Rapier).proficient := True;
                  character.combat.attack(Shortsword).proficient := True;
            ---
            Elsif character.class.main = Cleric Then
                  If character.combat.attack(i).classification = Simple Then
                        character.combat.attack(i).proficient := True;
                  Else
                        character.combat.attack(i).proficient := False;
                  End If;
            ---
            Elsif character.class.main = Druid Then
                  If character.combat.attack(i).classification = Simple Then
                        character.combat.attack(i).proficient := False;
                  Else
                        character.combat.attack(i).proficient := False;
                  End If;
                  character.combat.attack(Club).proficient := True;
                  character.combat.attack(Dagger).proficient := True;
                  character.combat.attack(Dart).proficient := True;
                  character.combat.attack(Javelin).proficient := True;
                  character.combat.attack(Mace).proficient := True;
                  character.combat.attack(Quarterstaff).proficient := True;
                  character.combat.attack(Scimitar).proficient := True;
                  character.combat.attack(Sickle).proficient := True;
                  character.combat.attack(Sling).proficient := True;
                  character.combat.attack(Spear).proficient := True;
            ---
            Elsif character.class.main = Fighter Then
                  character.combat.attack(i).proficient := True;
                  --If character.combat.attack(i).classification = Simple Then
                  --     character.combat.attack(i).proficient := True;
                  --Else
                  --     character.combat.attack(i).proficient := True;
                  --End If;
            ---
            Elsif character.class.main = Monk Then
                  If character.combat.attack(i).classification = Simple Then
                        character.combat.attack(i).proficient := True;
                  Else
                        character.combat.attack(i).proficient := False;
                  End If;
                  character.combat.attack(Shortsword).proficient := True;
            ---
            Elsif character.class.main = Paladin Then
                  character.combat.attack(i).proficient := True;
                  --If character.combat.attack(i).classification = Simple Then
                  --     character.combat.attack(i).proficient := True;
                  --Else
                  --     character.combat.attack(i).proficient := True;
                  --End If;
            ---
            Elsif character.class.main = Ranger Then
                  character.combat.attack(i).proficient := True;
                  --If character.combat.attack(i).classification = Simple Then
                  --     character.combat.attack(i).proficient := True;
                  --Else
                  --     character.combat.attack(i).proficient := True;
                  --End If;
            ---
            Elsif character.class.main = Rogue Then
                  If character.combat.attack(i).classification = Simple Then
                        character.combat.attack(i).proficient := True;
                  Else
                        character.combat.attack(i).proficient := False;
                  End If;
                  character.combat.attack(HandCrossbow).proficient := True;
                  character.combat.attack(Longsword).proficient := True;
                  character.combat.attack(Rapier).proficient := True;
                  character.combat.attack(Shortsword).proficient := True;
            ---
            Elsif character.class.main = Sorcerer Then
                  If character.combat.attack(i).classification = Simple Then
                        character.combat.attack(i).proficient := False;
                  Else
                        character.combat.attack(i).proficient := False;
                  End If;
                  character.combat.attack(Dagger).proficient := True;
                  character.combat.attack(Dart).proficient := True;
                  character.combat.attack(Sling).proficient := True;
                  character.combat.attack(Quarterstaff).proficient := True;
                  character.combat.attack(LightCrossbow).proficient := True;
            ---
            Elsif character.class.main = Warlock Then
                  If character.combat.attack(i).classification = Simple Then
                        character.combat.attack(i).proficient := True;
                  Else
                        character.combat.attack(i).proficient := False;
                  End If;
            ---
            Elsif character.class.main = Wizard Then
                  If character.combat.attack(i).classification = Simple Then
                        character.combat.attack(i).proficient := False;
                  Else
                        character.combat.attack(i).proficient := False;
                  End If;
                  character.combat.attack(Dagger).proficient := True;
                  character.combat.attack(Dart).proficient := True;
                  character.combat.attack(Sling).proficient := True;
                  character.combat.attack(Quarterstaff).proficient := True;
                  character.combat.attack(LightCrossbow).proficient := True;
            End If;

            -- Assign to hit and damage modifiers based on class proficiencies
            If character.combat.attack(i).proficient Then
                  If character.combat.attack(i).damageAbility = STR Then
                        character.combat.attack(i).toHit := character.combat.STRproficient;
                  Else
                        character.combat.attack(i).toHit := character.combat.DEXproficient;
                  End IF;
            Elsif character.combat.attack(i).proficient = False Then
                  If character.combat.attack(i).damageAbility = STR Then
                        character.combat.attack(i).toHit := character.combat.STRbased;
                  Else
                        character.combat.attack(i).toHit := character.combat.DEXbased;
                  End IF;
            Else
                  character.combat.attack(i).toHit := -99;
            End IF;
      End Loop;

   End combatReference;

------------------------------------------------------------


   Procedure outputToConsole (character : in Character_Type) is

   Begin -- outputToConsole
      Put (THIRTY_THREE_DASHES);
      New_Line;
      Put (character.name.name (1..character.name.length)); -- Name
      New_Line;
      If character.race.size = 'S' Then -- Size
            Put ("SMALL ");
      Elsif character.race.size = 'M' Then
            Put ("MEDIUM ");
      Elsif character.race.size = 'L' Then
            Put ("LARGE ");
      End IF;
      Put (character.race.subrace); -- Subrace
      Put (" ");
      Put (character.race.main); -- Main Race
      Put (" ");
      Put (character.class.main); -- Main Class
      Put (" (");
      Put (character.class.level, 1); -- Level
      Put (")");
      New_Line;
      Put (THIRTY_THREE_DASHES);
      New_Line;

      Put ("Total Health: ");
      Put (character.health.total, 1); -- Health
      New_Line;
      Put ("Armor Class:  ");
      Put (10 + character.stat.DEX.modifier, 2); -- Armor Class
      Put (" (Unarmored)");
      New_Line;
      Put ("Hit Dice:   ");
      Put (character.class.level, 2); -- (number of) Hit Dice
      Put ("d");
      Put (character.class.hitDice, 1); -- (size of) Hit Dice
      New_Line;
      Put ("Speed:        ");
      Put (character.race.speed, 1); -- Movement Speed
      Put (" ft.");
      New_Line;
      Put (THIRTY_THREE_DASHES);
      New_Line;

      Set_Col(1); -- Stat labels
      Put ("STR");
      Set_Col(7);
      Put ("DEX");
      Set_Col(13);
      Put ("CON");
      Set_Col(19);
      Put ("INT");
      Set_Col(25);
      Put ("WIS");
      Set_Col(31);
      Put ("CHA");
      New_Line;
      Put (THIRTY_THREE_DASHES);
      New_Line;
      Set_Col(1+1);
      Put (character.stat.STR.base, 1); -- Base Stats
      Set_Col(7+1);
      Put (character.stat.DEX.base, 1);
      Set_Col(13+1);
      Put (character.stat.CON.base, 1);
      Set_Col(19+1);
      Put (character.stat.INT.base, 1);
      Set_Col(25+1);
      Put (character.stat.WIS.base, 1);
      Set_Col(31+1);
      Put (character.stat.CHA.base, 1);
      New_Line;
      Set_Col(1);
      Put("(");
      If character.stat.STR.modifier >= 0 Then -- Modifiers
         Put("+");
         Put(character.stat.STR.modifier, 1);
      Else
         Put(character.stat.STR.modifier, 1);
      End If;
      Put(")");
      Set_Col(7);
      Put("(");
      If character.stat.DEX.modifier >= 0 Then
         Put("+");
         Put(character.stat.DEX.modifier, 1);
      Else
         Put(character.stat.DEX.modifier, 1);
      End If;
      Put(")");
      Set_Col(13);
      Put("(");
      If character.stat.CON.modifier >= 0 Then
         Put("+");
         Put(character.stat.CON.modifier, 1);
      Else
         Put(character.stat.CON.modifier, 1);
      End If;
      Put(")");
      Set_Col(19);
      Put("(");
      If character.stat.INT.modifier >= 0 Then
         Put("+");
         Put(character.stat.INT.modifier, 1);
      Else
         Put(character.stat.INT.modifier, 1);
      End If;
      Put(")");
      Set_Col(25);
      Put("(");
      If character.stat.WIS.modifier >= 0 Then
         Put("+");
         Put(character.stat.WIS.modifier, 1);
      Else
         Put(character.stat.WIS.modifier, 1);
      End If;
      Put(")");
      Set_Col(31);
      Put("(");
      If character.stat.CHA.modifier >= 0 Then
         Put("+");
         Put(character.stat.CHA.modifier, 1);
      Else
         Put(character.stat.CHA.modifier, 1);
      End If;
      Put(")");
      New_Line;
      Put (THIRTY_THREE_DASHES);
      New_Line;
   End outputToConsole;

------------------------------------------------------------

   Procedure outputCharacterFile (character : in Character_type) is
      File : File_Type;
   Begin -- outputCharacterFile

      -- Output most relevant info to a character file.
      Create (File, name => "Character.txt");
      Put (File, character.name.name (1..character.name.length)); -- Name
      New_Line (File);
      If character.race.size = 'S' Then -- Size
            Put (File, "SMALL ");
      Elsif character.race.size = 'M' Then
            Put (File, "MEDIUM ");
      Elsif character.race.size = 'L' Then
            Put (File, "LARGE ");
      End IF;
      Put (File, character.race.subrace); -- Subrace
      Put (File, " ");
      Put (File, character.race.main); -- Main Race
      Put (File, " ");
      Put (File, character.class.main); -- Main Class
      Put (File, " (");
      Put (File, character.class.level, 1); -- Level
      Put (File, ")");
      New_Line (File);
      Put (File, THIRTY_THREE_DASHES);
      New_Line (File);

      Put (File, "Total Health: ");
      Put (File, character.health.total, 1); -- Health
      New_Line (File);
      Put (File, "Armor Class:  ");
      Put (File, 10 + character.stat.DEX.modifier, 2); -- Armor Class
      Put (File, " (Unarmored)");
      New_Line (File);
      Put (File, "Hit Dice:   ");
      Put (File, character.class.level, 2); -- Hit Dice
      Put (File, "d");
      Put (File, character.class.hitDice, 1);
      New_Line (File);
      Put (File, "Speed:        ");
      Put (File, character.race.speed, 1); -- Speed
      Put (File, " ft.");
      New_Line (File);
      Put (File, THIRTY_THREE_DASHES);
      New_Line (File);

      Set_Col (File, 1); -- Stats
      Put (File, "STR");
      Set_Col (File, 7);
      Put (File, "DEX");
      Set_Col (File, 13);
      Put (File, "CON");
      Set_Col (File, 19);
      Put (File, "INT");
      Set_Col (File, 25);
      Put (File, "WIS");
      Set_Col (File, 31);
      Put (File, "CHA");
      New_Line (File);
      Put (File, THIRTY_THREE_DASHES);
      New_Line (File);
      Set_Col (File, 1+1);
      Put (File, character.stat.STR.base, 1);
      Set_Col (File, 7+1);
      Put (File, character.stat.DEX.base, 1);
      Set_Col (File, 13+1);
      Put (File, character.stat.CON.base, 1);
      Set_Col (File, 19+1);
      Put (File, character.stat.INT.base, 1);
      Set_Col (File, 25+1);
      Put (File, character.stat.WIS.base, 1);
      Set_Col (File, 31+1);
      Put (File, character.stat.CHA.base, 1);
      New_Line (File);
      Set_Col (File, 1);
      Put (File, "(");
      If character.stat.STR.modifier >= 0 Then
         Put (File, "+");
         Put (File, character.stat.STR.modifier, 1);
      Else
         Put (File, character.stat.STR.modifier, 1);
      End If;
      Put (File, ")");
      Set_Col (File, 7);
      Put (File, "(");
      If character.stat.DEX.modifier >= 0 Then
         Put (File, "+");
         Put (File, character.stat.DEX.modifier, 1);
      Else
         Put (File, character.stat.DEX.modifier, 1);
      End If;
      Put (File, ")");
      Set_Col (File, 13);
      Put (File, "(");
      If character.stat.CON.modifier >= 0 Then
         Put (File, "+");
         Put (File, character.stat.CON.modifier, 1);
      Else
         Put (File, character.stat.CON.modifier, 1);
      End If;
      Put (File, ")");
      Set_Col (File, 19);
      Put (File, "(");
      If character.stat.INT.modifier >= 0 Then
         Put (File, "+");
         Put (File, character.stat.INT.modifier, 1);
      Else
         Put (File, character.stat.INT.modifier, 1);
      End If;
      Put (File, ")");
      Set_Col (File, 25);
      Put (File, "(");
      If character.stat.WIS.modifier >= 0 Then
         Put (File, "+");
         Put (File, character.stat.WIS.modifier, 1);
      Else
         Put (File, character.stat.WIS.modifier, 1);
      End If;
      Put (File, ")");
      Set_Col (File, 31);
      Put (File, "(");
      If character.stat.CHA.modifier >= 0 Then
         Put (File, "+");
         Put (File, character.stat.CHA.modifier, 1);
      Else
         Put (File, character.stat.CHA.modifier, 1);
      End If;
      Put (File, ")");
      New_Line (File, 2);

      -- A warning to the user.
      Put (File, "- I would recommend saving this document and all other");
      New_Line (File);
      Put (File, "  documents produced with your character's name.");
      New_Line (File, 2);
      Put (File, "- Every time the program is executed, it");
      New_Line (File);
      Put (File, "  will write over any pre-existing characters.");
      New_Line(File, 2);
      Put (File, "Ex) Gundren_Rockseeker.txt | Gundren_Skills.txt");
      New_Line(File);
      Put (File, "    Gundren_Features.Txt   | Gundren_Combat.txt");
      Close (File);

   End OutputCharacterFile;

----------------------------------------------------

   Procedure outputSkillsToFile (character : in Character_type) is

      skillsFile : File_Type;

   Begin --outputSkillsToFile

      -- Create a file to display the character's skills,
      -- whether they are proficient or not,
      -- and what modifiers they get  for those skills.
      Create (skillsFile, Name  => "Skills.txt");

      Put (skillsFile, character.name.name (1..character.name.length));
      Put (skillsFile, " Skills File");
      New_Line (skillsFile);
      Put (skillsFile, THIRTY_THREE_DASHES);
      New_Line (skillsFile);

      Put (skillsFile, "[");
      If character.class.skill.acrobatics.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.acrobatics.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.acrobatics.base, 1);
      Put (skillsFile, ") Acrobatics (DEX)");
      New_Line (skillsFile);
      ---------------
      Put (skillsFile, "[");
      If character.class.skill.animalHandling.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.animalhandling.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.animalhandling.base, 1);
      Put (skillsFile, ") Animal Handling (WIS)");
      New_Line (skillsFile);
      ---------------
      Put (skillsFile, "[");
      If character.class.skill.arcana.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.arcana.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.arcana.base, 1);
      Put (skillsFile, ") Arcana (INT)");
      New_Line (skillsFile);
      ----------------
      Put (skillsFile, "[");
      If character.class.skill.athletics.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.athletics.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.athletics.base, 1);
      Put (skillsFile, ") Athletics (STR)");
      New_Line (skillsFile);
      -------------------
      Put (skillsFile, "[");
      If character.class.skill.deception.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.deception.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.deception.base, 1);
      Put (skillsFile, ") Deception (CHA)");
      New_Line (skillsFile);
      -----------------
      Put (skillsFile, "[");
      If character.class.skill.history.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.history.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.history.base, 1);
      Put (skillsFile, ") History (INT)");
      New_Line (skillsFile);
      -----------------
      Put (skillsFile, "[");
      If character.class.skill.insight.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.insight.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.insight.base, 1);
      Put (skillsFile, ") Insight (WIS)");
      New_Line (skillsFile);
      -------------
      Put (skillsFile, "[");
      If character.class.skill.intimidation.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.intimidation.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.intimidation.base, 1);
      Put (skillsFile, ") Intimidation (CHA)");
      New_Line (skillsFile);
      -----------------
      Put (skillsFile, "[");
      If character.class.skill.investigation.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.investigation.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.investigation.base, 1);
      Put (skillsFile, ") Investigation (INT)");
      New_Line (skillsFile);
      ----------------------
      Put (skillsFile, "[");
      If character.class.skill.medicine.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.medicine.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.medicine.base, 1);
      Put (skillsFile, ") Medicine (WIS)");
      New_Line (skillsFile);
      --------------------
      Put (skillsFile, "[");
      If character.class.skill.nature.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.nature.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.nature.base, 1);
      Put (skillsFile, ") Nature (INT)");
      New_Line (skillsFile);
      ---------------------
      Put (skillsFile, "[");
      If character.class.skill.perception.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.perception.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.perception.base, 1);
      Put (skillsFile, ") Perception (WIS)");
      New_Line (skillsFile);
      -------------------
      Put (skillsFile, "[");
      If character.class.skill.performance.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.performance.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.performance.base, 1);
      Put (skillsFile, ") Performance (CHA)");
      New_Line (skillsFile);
      --------------------
      Put (skillsFile, "[");
      If character.class.skill.persuasion.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.persuasion.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.persuasion.base, 1);
      Put (skillsFile, ") Persuasion (CHA)");
      New_Line (skillsFile);
      --------------------
      Put (skillsFile, "[");
      If character.class.skill.religion.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.religion.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.religion.base, 1);
      Put (skillsFile, ") Religion (INT)");
      New_Line (skillsFile);
      ---------------------
      Put (skillsFile, "[");
      If character.class.skill.sleightOfHand.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.sleightOfHand.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.sleightOfHand.base, 1);
      Put (skillsFile, ") Sleight of Hand (DEX)");
      New_Line (skillsFile);
      --------------------
      Put (skillsFile, "[");
      If character.class.skill.stealth.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.stealth.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.stealth.base, 1);
      Put (skillsFile, ") Stealth (DEX)");
      New_Line (skillsFile);
      ---------------------
      Put (skillsFile, "[");
      If character.class.skill.survival.proficient Then
            Put (skillsFile, "x] ");
      Else
            Put (skillsFile, " ] ");
      End If;
      Put (skillsFile, "(");
      If character.class.skill.survival.base >= 0 Then
            Put (skillsFile, "+");
      End If;
      Put (skillsFile, character.class.skill.survival.base, 1);
      Put (skillsFile, ") Survival (WIS)");
      New_Line (skillsFile);
      Close (skillsFile);

   End outputSkillsToFile;

----------------------------------------------------

   Procedure outputCombatReference (character : in Character_Type) is

      combatFile : File_type;

   Begin -- outputCombatReference

      -- Create a file that serves as a combat reference.
      -- This file shows 
      --    A] attack roll modifier
      --    B] damage modifier
      -- for each weapon in the Player's Handbook as well as
      -- the base modifiers for weapons in general.

      -- This file also shows
      --    A] spell save DC
      --    B] spell attack modifier
      --    C] spellcasting ability score
      Create (combatFile, name => "CombatReference.txt");

      Put (combatFile, character.name.name (1..character.name.length));
      Put (combatFile, " Combat File");
      New_Line (combatFile);
      Put (combatFile, THIRTY_THREE_DASHES);
      New_Line (combatFile, 2);
      -----
      Put (combatFile, "----- Melee/Ranged -----");
      New_Line (combatFile);
      Put (combatFile, "STR-Based Weapon Attack (Not Proficient)");
      New_Line (combatFile);
      Set_Col (combatFile, 4);
      Put (combatFile, "To hit: ");
      If character.combat.STRbased >= 0 Then
            Put (combatFile, "+");
      End If;
      Put (combatFile, character.combat.STRbased, 1);
      New_Line (combatFile);
      -----
      Put (combatFile, "STR-Based Weapon Attack (Proficient)");
      New_Line (combatFile);
      Set_Col (combatFile, 4);
      Put (combatFile, "To hit: ");
      If character.combat.STRproficient >= 0 Then
            Put (combatFile, "+");
      End If;
      Put (combatFile, character.combat.STRproficient, 1);
      New_Line (combatFile, 2);
      -----
      Put (combatFile, "DEX-Based Weapon Attack (Not Proficient)");
      New_Line (combatFile);
      Set_Col (combatFile, 4);
      Put (combatFile, "To hit: ");
      If character.combat.DEXbased >= 0 Then
            Put (combatFile, "+");
      End If;
      Put (combatFile, character.combat.DEXbased, 1);
      New_Line (combatFile);
      -----
      Put (combatFile, "DEX-Based Weapon Attack (Proficient)");
      New_Line (combatFile);
      Set_Col (combatFile, 4);
      Put (combatFile, "To hit: ");
      If character.combat.DEXproficient >= 0 Then
            Put (combatFile, "+");
      End If;
      Put (combatFile, character.combat.DEXproficient, 1);
      New_Line (combatFile, 2);
      -----
      Put (combatFile, "Unarmed Strike");
      New_Line (combatFile);
      Set_Col (combatFile, 4);
      Put (combatFile, "To hit: ");
      If character.combat.unarmedAttack >= 0 Then
            Put (combatFile, "+");
      End If;
      Put (combatFile, character.combat.unarmedAttack, 1);
      New_Line (combatFile);
      Set_Col (combatFile, 4);
      Put (combatFile, "Damage: 1");
      If character.combat.unarmedAttack >= 0 Then
            Put (combatFile, "+");
      End If;
      Put (combatFile, character.combat.STRbased, 1);
      Put (combatFile, " Bludgeoning");
      New_Line (combatFile, 2);

      -- Output the character's Spell Save DC,
      -- Spell Attack Modifier, and Spellcasting Ability
      -- to CombatReference.txt.
      -- Non-Spellcasters don't output aything.
      -- Monks output Ki.
      -- The spellDC and such is computed with combatReference()
      Case character.class.main is
      When Bard =>
            Put (combatFile, "----- SpellCasting -----");
            New_Line (combatFile);
            Put (combatFile, "Spell Save DC: ");
            Put (combatFile, character.combat.spellDC, 1);
            New_Line (combatFile);
            Put (combatFile, "Spell Attack Modifier: ");
            If character.combat.spellAttack >= 0 Then
                  Put (combatFile, "+");
            End If;
            Put (combatFile, character.combat.spellAttack, 1);
            New_Line (combatFile);
            Put (combatFile, "Spellcasting Ability: ");
            Put (combatFile, character.combat.spellStat);
            New_Line (combatFile, 2);
      When Cleric =>
            Put (combatFile, "----- SpellCasting -----");
            New_Line (combatFile);
            Put (combatFile, "Spell Save DC: ");
            Put (combatFile, character.combat.spellDC, 1);
            New_Line (combatFile);
            Put (combatFile, "Spell Attack Modifier: ");
            If character.combat.spellAttack >= 0 Then
                  Put (combatFile, "+");
            End If;
            Put (combatFile, character.combat.spellAttack, 1);
            New_Line (combatFile);
            Put (combatFile, "Spellcasting Ability: ");
            Put (combatFile, character.combat.spellStat);
            New_Line (combatFile, 2);
      When Druid =>
            Put (combatFile, "----- SpellCasting -----");
            New_Line (combatFile);
            Put (combatFile, "Spell Save DC: ");
            Put (combatFile, character.combat.spellDC, 1);
            New_Line (combatFile);
            Put (combatFile, "Spell Attack Modifier: ");
            If character.combat.spellAttack >= 0 Then
                  Put (combatFile, "+");
            End If;
            Put (combatFile, character.combat.spellAttack, 1);
            New_Line (combatFile);
            Put (combatFile, "Spellcasting Ability: ");
            Put (combatFile, character.combat.spellStat);
            New_Line (combatFile, 2);
      When Monk =>
            -- Monks aren't spellcasters, so I'm using the spellcasting
            -- section to output their Ki Save DC. It's not a
            -- perfect system but it will work for us.
            Put (combatFile, "---------- Ki ----------");
            New_Line (combatFile);
            Put (combatFile, "Ki Save DC: ");
            Put (combatFile, character.combat.spellDC, 1);
            New_Line (combatFile, 2);
      When Paladin =>
            Put (combatFile, "----- SpellCasting -----");
            New_Line (combatFile);
            Put (combatFile, "Spell Save DC: ");
            Put (combatFile, character.combat.spellDC, 1);
            New_Line (combatFile);
            Put (combatFile, "Spell Attack Modifier: ");
            If character.combat.spellAttack >= 0 Then
                  Put (combatFile, "+");
            End If;
            Put (combatFile, character.combat.spellAttack, 1);
            New_Line (combatFile);
            Put (combatFile, "Spellcasting Ability: ");
            Put (combatFile, character.combat.spellStat);
            New_Line (combatFile, 2);
      When Ranger =>
            Put (combatFile, "----- SpellCasting -----");
            New_Line (combatFile);
            Put (combatFile, "Spell Save DC: ");
            Put (combatFile, character.combat.spellDC, 1);
            New_Line (combatFile);
            Put (combatFile, "Spell Attack Modifier: ");
            If character.combat.spellAttack >= 0 Then
                  Put (combatFile, "+");
            End If;
            Put (combatFile, character.combat.spellAttack, 1);
            New_Line (combatFile);
            Put (combatFile, "Spellcasting Ability: ");
            Put (combatFile, character.combat.spellStat);
            New_Line (combatFile, 2);
      When Sorcerer =>
            Put (combatFile, "----- SpellCasting -----");
            New_Line (combatFile);
            Put (combatFile, "Spell Save DC: ");
            Put (combatFile, character.combat.spellDC, 1);
            New_Line (combatFile);
            Put (combatFile, "Spell Attack Modifier: ");
            If character.combat.spellAttack >= 0 Then
                  Put (combatFile, "+");
            End If;
            Put (combatFile, character.combat.spellAttack, 1);
            New_Line (combatFile);
            Put (combatFile, "Spellcasting Ability: ");
            Put (combatFile, character.combat.spellStat);
            New_Line (combatFile, 2);
      When Warlock =>
            Put (combatFile, "----- SpellCasting -----");
            New_Line (combatFile);
            Put (combatFile, "Spell Save DC: ");
            Put (combatFile, character.combat.spellDC, 1);
            New_Line (combatFile);
            Put (combatFile, "Spell Attack Modifier: ");
            If character.combat.spellAttack >= 0 Then
                  Put (combatFile, "+");
            End If;
            Put (combatFile, character.combat.spellAttack, 1);
            New_Line (combatFile);
            Put (combatFile, "Spellcasting Ability: ");
            Put (combatFile, character.combat.spellStat);
            New_Line (combatFile, 2);
      When Wizard =>
            Put (combatFile, "----- SpellCasting -----");
            New_Line (combatFile);
            Put (combatFile, "Spell Save DC: ");
            Put (combatFile, character.combat.spellDC, 1);
            New_Line (combatFile);
            Put (combatFile, "Spell Attack Modifier: ");
            If character.combat.spellAttack >= 0 Then
                  Put (combatFile, "+");
            End If;
            Put (combatFile, character.combat.spellAttack, 1);
            New_Line (combatFile);
            Put (combatFile, "Spellcasting Ability: ");
            Put (combatFile, character.combat.spellStat);
            New_Line (combatFile, 2);
      When others => null;
      End Case;

      Put (combatFile, "----- Weapon Attacks -----");
      New_Line (combatFile);
      For i in character.combat.attack'range Loop
            Put (combatFile, character.combat.attack(i).name (1..character.combat.attack(i).nameLength));
            If character.combat.attack(i).damageAbility = STR Then
                  If character.combat.attack(i).proficient Then
                        If character.combat.attack(i).name = "Greatsword    " Then
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "+");
                              Put (combatFile, character.combat.attack(i).toHit, 1);
                              Put (combatFile, " to hit");
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "2d");
                              Put (combatFile, character.combat.attack(i).die, 1);
                              Put (combatFile, " + ");
                              Put (combatFile, character.combat.STRproficient, 1);
                              Put (combatFile, " damage");
                        Elsif character.combat.attack(i).name = "Maul          " Then
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "+");
                              Put (combatFile, character.combat.attack(i).toHit, 1);
                              Put (combatFile, " to hit");
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "2d");
                              Put (combatFile, character.combat.attack(i).die, 1);
                              Put (combatFile, " + ");
                              Put (combatFile, character.combat.STRproficient, 1);
                              Put (combatFile, " damage");
                        Else
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "+");
                              Put (combatFile, character.combat.attack(i).toHit, 1);
                              Put (combatFile, " to hit");
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "1d");
                              Put (combatFile, character.combat.attack(i).die, 1);
                              Put (combatFile, " + ");
                              Put (combatFile, character.combat.STRproficient, 1);
                              Put (combatFile, " damage");
                        End IF;
                  Else
                        If character.combat.attack(i).name = "Greatsword    " Then
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "+");
                              Put (combatFile, character.combat.attack(i).toHit, 1);
                              Put (combatFile, " to hit");
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "2d");
                              Put (combatFile, character.combat.attack(i).die, 1);
                              Put (combatFile, " + ");
                              Put (combatFile, character.combat.STRbased, 1);
                              Put (combatFile, " damage");
                        Elsif character.combat.attack(i).name = "Maul          " Then
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "+");
                              Put (combatFile, character.combat.attack(i).toHit, 1);
                              Put (combatFile, " to hit");
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "2d");
                              Put (combatFile, character.combat.attack(i).die, 1);
                              Put (combatFile, " + ");
                              Put (combatFile, character.combat.STRbased, 1);
                              Put (combatFile, " damage");
                        Else
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "+");
                              Put (combatFile, character.combat.attack(i).toHit, 1);
                              Put (combatFile, " to hit");
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "1d");
                              Put (combatFile, character.combat.attack(i).die, 1);
                              Put (combatFile, " + ");
                              Put (combatFile, character.combat.STRbased, 1);
                              Put (combatFile, " damage");
                        End If;
                  End If;
            Elsif character.combat.attack(i).damageAbility = DEX Then
                  If character.combat.attack(i).proficient Then
                        If character.combat.attack(i).name = "Net           " Then
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "+");
                              Put (combatFile, character.combat.attack(i).toHit, 1);
                              Put (combatFile, " to hit");
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "DC 10 escape");
                        Else
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "+");
                              Put (combatFile, character.combat.attack(i).toHit, 1);
                              Put (combatFile, " to hit");
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "1d");
                              Put (combatFile, character.combat.attack(i).die, 1);
                              Put (combatFile, " + ");
                              Put (combatFile, character.combat.DEXproficient, 1);
                              Put (combatFile, " damage");
                        End If;
                  Else
                        IF character.combat.attack(i).name = "Net           " Then
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "+");
                              Put (combatFile, character.combat.attack(i).toHit, 1);
                              Put (combatFile, " to hit");
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "DC 10 escape");
                        Else
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "+");
                              Put (combatFile, character.combat.attack(i).toHit, 1);
                              Put (combatFile, " to hit");
                              New_Line (combatFile);
                              Set_Col (combatFile, 4);
                              Put (combatFile, "1d");
                              Put (combatFile, character.combat.attack(i).die, 1);
                              Put (combatFile, " + ");
                              Put (combatFile, character.combat.DEXbased, 1);
                              Put (combatFile, " damage");
                        End IF;
                  End If;
            End If;
            New_Line (combatFile);
      End Loop;
      close(combatFile);

   End outputCombatReference;

----------------------------------------------------

Procedure outputFeatures (character : In Character_Type) is

      featuresFile : File_Type;

      Procedure printDraconicAncestry is

      -- A procedure that will print the Draconic Ancestry
      -- table found on page 34 of the Player's Handbook.

      Begin

            Set_Col(featuresFile, 1);
            Put(featuresFile, "Dragon");
            Set_Col(featuresFile, 12);
            Put(featuresFile, "Damage Type");
            Set_Col(featuresFile, 25);
            Put(featuresFile, "Breath Weapon");
            New_Line(featuresFile);
            ---
            Set_Col(featuresFile, 1);
            Put(featuresFile, "Black");
            Set_Col(featuresFile, 12);
            Put(featuresFile, "Acid");
            Set_Col(featuresFile, 25);
            Put(featuresFile, "5 by 30 ft. line (Dex. save)");
            New_Line(featuresFile);
            ---
            Set_Col(featuresFile, 1);
            Put(featuresFile, "Blue");
            Set_Col(featuresFile, 12);
            Put(featuresFile, "Lightning");
            Set_Col(featuresFile, 25);
            Put(featuresFile, "5 by 30 ft. line (Dex. save)");
            New_Line(featuresFile);
            ---
            Set_Col(featuresFile, 1);
            Put(featuresFile, "Brass");
            Set_Col(featuresFile, 12);
            Put(featuresFile, "Fire");
            Set_Col(featuresFile, 25);
            Put(featuresFile, "5 by 30 ft. line (Dex. save)");
            New_Line(featuresFile);
            ---
            Set_Col(featuresFile, 1);
            Put(featuresFile, "Bronze");
            Set_Col(featuresFile, 12);
            Put(featuresFile, "Lightning");
            Set_Col(featuresFile, 25);
            Put(featuresFile, "5 by 30 ft. line (Dex. save)");
            New_Line(featuresFile);
            ---
            Set_Col(featuresFile, 1);
            Put(featuresFile, "Copper");
            Set_Col(featuresFile, 12);
            Put(featuresFile, "Acid");
            Set_Col(featuresFile, 25);
            Put(featuresFile, "5 by 30 ft. line (Dex. save)");
            New_Line(featuresFile);
            ---
            Set_Col(featuresFile, 1);
            Put(featuresFile, "Gold");
            Set_Col(featuresFile, 12);
            Put(featuresFile, "Fire");
            Set_Col(featuresFile, 25);
            Put(featuresFile, "15 ft. cone (Dex. save)");
            New_Line(featuresFile);
            ---
            Set_Col(featuresFile, 1);
            Put(featuresFile, "Green");
            Set_Col(featuresFile, 12);
            Put(featuresFile, "Poison");
            Set_Col(featuresFile, 25);
            Put(featuresFile, "15 ft. cone (Con. save)");
            New_Line(featuresFile);
            ---
            Set_Col(featuresFile, 1);
            Put(featuresFile, "Red");
            Set_Col(featuresFile, 12);
            Put(featuresFile, "Fire");
            Set_Col(featuresFile, 25);
            Put(featuresFile, "15 ft. cone (Dex. save)");
            New_Line(featuresFile);
            ---
            Set_Col(featuresFile, 1);
            Put(featuresFile, "Silver");
            Set_Col(featuresFile, 12);
            Put(featuresFile, "Cold");
            Set_Col(featuresFile, 25);
            Put(featuresFile, "15 ft. cone (Con. save)");
            New_Line(featuresFile);
            ---
            Set_Col(featuresFile, 1);
            Put(featuresFile, "White");
            Set_Col(featuresFile, 12);
            Put(featuresFile, "Cold");
            Set_Col(featuresFile, 25);
            Put(featuresFile, "15 ft. cone (Con. save)");
            New_Line(featuresFile);

      End printDraconicAncestry;

Begin

      create(File => featuresFile, name => "Features.txt");

      Put (featuresFile, character.name.name (1..character.name.length));
      Put (featuresFile, " Features File");
      New_Line (featuresFile);
      Put (featuresFile, THIRTY_THREE_DASHES);
      New_Line (featuresFile, 2);

      Put (featuresFile, "Racial Features:");
      New_Line(featuresFile);
      Put (featuresFile, "----------------");
      New_Line(featuresFile);

      -- Print out features based on race and subrace.
      Case character.race.main is
            When Dragonborn => Put(featuresFile, "Draconic Ancestry: You have Draconic ancestry. Choose one type of dragon from the Draconic Ancestry table. Your breath weapon and ");
                               Put(featuresFile, "damage Resistance are determined by the dragon type, as shown in the table.");
                               New_Line(featuresFile);
                               printDraconicAncestry; -- Calls a nested function that prints the table from the PLayer's Handbook.
                               New_Line(featuresFile);
                               Put(featuresFile, "Breath Weapon: You can use your action to exhale destructive energy. Your Draconic ancestry determines the size, shape, and damage type of the exhalation. ");
	                         Put(featuresFile, "When you use your breath weapon, each creature in the area of the exhalation must make a saving throw, the type of which is determined by your Draconic ancestry. ");
                               Put(featuresFile, "The DC for this saving throw equals 8 + your Constitution modifier + your Proficiency Bonus. A creature takes 2d6 damage on a failed save, ");
                               Put(featuresFile, "and half as much damage on a successful one. The damage increases to 3d6 at 6th level, 4d6 at 11th level, and 5d6 at 16th level. ");
	                         Put(featuresFile, "After you use your breath weapon, you can’t use it again until you complete a short or Long Rest.");
                               New_Line(featuresFile);
                               Put(featuresFile, "Damage Resistance: You have Resistance to the damage type associated with your Draconic ancestry.");
            When Dwarf => Put(featuresFile, "Darkvision: Accustomed to life underground, you have superior vision in dark and dim Conditions. You can see in dim light ");
                          Put(featuresFile, "within 60 feet of you as if it were bright light, and in Darkness as if it were dim light. You can't discern color in Darkness, only shades of gray.");
                          New_Line(featuresFile);
                          Put(featuresFile, "Dwarven Resilience: You have advantage on Saving Throws against poison, and you have Resistance against poison damage.");
                          New_Line(featuresFile);
                          Put(featuresFile, "Stonecunning: Whenever you make an Intelligence (History) check related to the Origin of stonework, you are considered proficient ");
                          Put(featuresFile, "in the History skill and add double your proficiency bonus to the check, instead of your normal proficiency bonus.");
                          New_Line(featuresFile);
                          Put(featuresFile, "Dwarven Toughness: Your hit point maximum increases by 1, and it increases by 1 every time you gain a level.");
            When Elf => Put(featuresFile, "Darkvision: Accustomed to life underground, you have superior vision in dark and dim Conditions. You can see in dim light within 60 feet ");
                        Put(featuresFile, "of you as if it were bright light, and in Darkness as if it were dim light. You can't discern color in Darkness, only shades of gray.");
                        New_Line(featuresFile);
                        Put(featuresFile, "Fey Ancestry: You have advantage on Saving Throws against being Charmed, and magic can't put you to sleep.");
                        New_Line(featuresFile);
                        Put(featuresFile, "Trance: Elves don't need to sleep. Instead, they meditate deeply, remaining semiconscious, for 4 hours a day. (The Common word for such ");
                        Put(featuresFile, "meditation is 'trance.') While meditating, you can dream after a fashion; such dreams are actually mental exercises that have become ");
                        Put(featuresFile, "reflexive through years of practice. After Resting in this way, you gain the same benefit that a human does from 8 hours of sleep.");
                        New_Line(featuresFile);
                        Put(featuresFile, "Cantrip: You know one cantrip of your choice from the Wizard spell list. Intelligence is your Spellcasting ability for it.");
                        New_Line(featuresFile);
                        Put(featuresFile, "Extra Language: You can speak, read, and write one extra language of your choice.");
            When Gnome => Put(featuresFile, "Darkvision: Accustomed to life underground, you have superior vision in dark and dim Conditions. You can see in dim light ");
                          Put(featuresFile, "within 60 feet of you as if it were bright light, and in Darkness as if it were dim light. You can't discern color in Darkness, only shades of gray.");
                          New_Line(featuresFile);
                          Put(featuresFile, "Gnome Cunning: You have advantage on all Intelligence, Wisdom, and Charisma Saving Throws against magic.");
                          New_Line(featuresFile);
                          Put(featuresFile, "Artificer’s Lore: Whenever you make an Intelligence (History) check related to Magic Items, alchemical Objects, or technological devices, ");
                          Put(featuresFile, "you can add twice your Proficiency Bonus, instead of any Proficiency Bonus you normally apply.");
                          New_Line(featuresFile);
                          Put(featuresFile, "Tinker: You have proficiency with artisan’s tools (tinker’s tools). Using those tools, you can spend 1 hour and 10 gp worth of materials to construct a ");
                          Put(featuresFile, "Tiny clockwork device (AC 5, 1 hp). The device ceases to function after 24 hours (unless you spend 1 hour repairing it to keep the device functioning), ");
                          Put(featuresFile, "or when you use your action to dismantle it; at that time, you can reclaim the materials used to create it. You can have up to three such devices active at a time. ");
                          Put(featuresFile, "When you create a device, choose one of the following options:");
                          New_Line(featuresFile);
                          Put(featuresFile, "   Clockwork Toy: This toy is a clockwork animal, monster, or person, such as a frog, mouse, bird, dragon, or Soldier. When placed on the ground, ");
                          Put(featuresFile, "the toy moves 5 feet across the ground on each of your turns in a random direction. It makes noises as appropriate to the creature it represents.");
                          New_Line(featuresFile);
			        Put(featuresFile, "   Fire Starter: The device produces a miniature flame, which you can use to light a Candle, torch, or campfire. Using the device requires your action.");
                          New_Line(featuresFile);
			        Put(featuresFile, "   Music Box: When opened, this music box plays a single song at a moderate volume. The box stops playing when it reaches the song’s end or when it is closed.");
            When HalfElf => Put(featuresFile, "Darkvision: Thanks to your elf blood, you have superior vision in dark and dim Conditions. You can see in dim light within 60 feet of you as if it were ");
                            Put(featuresFile, "bright light, and in Darkness as if it were dim light. You can’t discern color in Darkness, only shades of gray.");
                            New_Line(featuresFile);
	                      Put(featuresFile, "Fey Ancestry: You have advantage on Saving Throws against being Charmed, and magic can’t put you to sleep.");
                            New_Line(featuresFile);
	                      Put(featuresFile, "Skill Versatility: You gain proficiency in two Skills of your choice.");
            When Halfling => Put(featuresFile, "Lucky: When you roll a 1 on The D20 for an Attack roll, ability check, or saving throw, you can reroll the die and must use the new roll.");
                             New_Line(featuresFile);
                             Put(featuresFile, "Brave: You have advantage on Saving Throws against being Frightened.");
                             New_Line(featuresFile);
                             Put(featuresFile, "Halfling Nimbleness: You can move through the space of any creature that is of a size larger than yours.");
                             New_Line(featuresFile);
                             Put(featuresFile, "Naturally Stealthy: You can attempt to hide even when you are obscured only by a creature that is at least one size larger than you.");
            When HalfOrc => Put(featuresFile, "Darkvision: Thanks to your orc blood, you have superior vision in dark and dim Conditions. You can see in dim light within 60 feet of ");
                            Put(featuresFile, "you as if it were bright light, and in Darkness as if it were dim light. You can’t discern color in Darkness, only shades of gray.");
                            New_Line(featuresFile);
	                      Put(featuresFile, "Menacing: You gain proficiency in the Intimidation skill.");
                            New_Line(featuresFile);
	                      Put(featuresFile, "Relentless Endurance: When you are reduced to 0 Hit Points but not killed outright, you can drop to 1 hit point instead. ");
                            Put(featuresFile, "You can’t use this feature again until you finish a Long Rest.");
                            New_Line(featuresFile);
	                      Put(featuresFile, "Savage Attacks: When you score a critical hit with a melee weapon Attack, you can roll one of the weapon’s damage dice one ");
                            Put(featuresFile, "additional time and add it to the extra damage of the critical hit.");
            When Tiefling => Put(featuresFile, "Darkvision: Thanks to your Infernal heritage, you have superior vision in dark and dim Conditions. You can see in dim ");
                             Put(featuresFile, "light within 60 feet of you as if it were bright light, and in Darkness as if it were dim light. You can’t discern color in Darkness, only shades of gray.");
                             New_Line(featuresFile);
	                       Put(featuresFile, "Hellish Resistance: You have Resistance to fire damage.");
                             New_Line(featuresFile);
	                       Put(featuresFile, "Infernal Legacy. You know the Thaumaturgy cantrip. When you reach 3rd level, you can cast the Hellish Rebuke spell ");
                             Put(featuresFile, "as a 2nd-level spell once with this trait and regain the ability to do so when you finish a Long Rest. When you reach 5th level, ");
                             Put(featuresFile, "you can cast the Darkness spell once with this trait and regain the ability to do so when you finish a Long Rest. Charisma is your Spellcasting ability for these Spells.");
            When Others => null;
      End Case;

      New_Line(featuresFile, 2);
      Put(featuresFile, "Class Features:");
      New_Line(featuresFile);
      Put(featuresFile, "---------------");
      New_Line(featuresFile);

      -- Print out features based on class, subclass, and level
      Case character.class.main is
            When Barbarian =>
                  If character.class.subclass = Berserker Then
                        Put (featuresFile, character.class.main);
                        Put (featuresFile, " - PATH OF THE ");
                        Put (featuresFile, character.class.subclass);
                        New_Line(featuresFile);
                        Put (featuresFile, "---------------------------------------");
                        New_Line(featuresFile);
                        Put (featuresFile, "| Lv | Feature(s)");
                        New_Line(featuresFile);
                        Put (featuresFile, TABLE_BORDER);
                        New_Line(featuresFile);
                        If character.class.level >= 1 Then
                              Put (featuresFile, "|  1 | Rage");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Unarmored Defense");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 2 Then
                              Put (featuresFile, "|  2 | Reckless Attack");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Danger Sense");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 3 Then
                              Put (featuresFile, "|  3 | Primal Path");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Frenzy");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 4 Then
                              Put (featuresFile, "|  4 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 5 Then
                              Put (featuresFile, "|  5 | Extra Attack");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Fast Movement");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 6 Then
                              Put (featuresFile, "|  6 | Mindless Rage");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 7 Then
                              Put (featuresFile, "|  7 | Feral Instinct");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 8 Then
                              Put (featuresFile, "|  8 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 9 Then
                              Put (featuresFile, "|  9 | Brutal Critical (+1 die)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 10 Then
                              Put (featuresFile, "| 10 | Intimidating Presense");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 11 Then
                              Put (featuresFile, "| 11 | Relentless");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 12 Then
                              Put (featuresFile, "| 12 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 13 Then
                              Put (featuresFile, "| 13 | Brutal Critical (+2 dice)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 14 Then
                              Put (featuresFile, "| 14 | Retaliation");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 15 Then
                              Put (featuresFile, "| 15 | Persistent Rage");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 16 Then
                              Put (featuresFile, "| 16 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 17 Then
                              Put (featuresFile, "| 17 | Brutal Critical (+3 dice)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 18 Then
                              Put (featuresFile, "| 18 | Indomitable Might");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 19 Then
                              Put (featuresFile, "| 19 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 20 Then
                              Put (featuresFile, "| 20 | Primal Champion");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                  End If;
            When Bard =>
                  If character.class.subclass = Lore Then
                        Put (featuresFile, character.class.main);
                        Put (featuresFile, " - COLLEGE OF ");
                        Put (featuresFile, character.class.subclass);
                        New_Line(featuresFile);
                        Put (featuresFile, "---------------------------------------");
                        New_Line(featuresFile);
                        Put (featuresFile, "| Lv | Feature(s)");
                        New_Line(featuresFile);
                        Put (featuresFile, TABLE_BORDER);
                        New_Line(featuresFile);
                        If character.class.level >= 1 Then
                              Put (featuresFile, "|  1 | Spellcasting");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Bardic Inspiration (d6)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 2 Then
                              Put (featuresFile, "|  2 | Jack of all Trades");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Song of Rest (1d6)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 3 Then
                              Put (featuresFile, "|  3 | Bard College");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Expertise");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Bonus Proficiencies (+3)");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Cutting Words");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 4 Then
                              Put (featuresFile, "|  4 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 5 Then
                              Put (featuresFile, "|  5 | Bardic Inspiration (d8)");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Font of Inspiration");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 6 Then
                              Put (featuresFile, "|  6 | Countercharm");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Additional Magical Secrets (+2)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 7 Then
                              Put (featuresFile, "|  7 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 8 Then
                              Put (featuresFile, "|  8 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 9 Then
                              Put (featuresFile, "|  9 | Song of Rest (1d8)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 10 Then
                              Put (featuresFile, "| 10 | Bardic Inspiration (d10)");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Expertise");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Magical Secrets (+2)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 11 Then
                              Put (featuresFile, "| 11 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 12 Then
                              Put (featuresFile, "| 12 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 13 Then
                              Put (featuresFile, "| 13 | Song of Rest (1d10)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 14 Then
                              Put (featuresFile, "| 14 | Magical Secrets (+2)");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Peerless Skill");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 15 Then
                              Put (featuresFile, "| 15 | Bardic Inspiration (d12)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 16 Then
                              Put (featuresFile, "| 16 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 17 Then
                              Put (featuresFile, "| 17 | Song of Rest (1d12)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 18 Then
                              Put (featuresFile, "| 18 | Magical Secrets (+2)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 19 Then
                              Put (featuresFile, "| 19 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 20 Then
                              Put (featuresFile, "| 20 | Superior Inspiration");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                  End If;
            When Cleric =>
                  If character.class.subclass = life Then
                        Put (featuresFile, character.class.main);
                        Put (featuresFile, " - ");
                        Put (featuresFile, character.class.subclass);
                        Put (featuresFile, " DOMAIN");
                        New_Line(featuresFile);
                        Put (featuresFile, "---------------------------------------");
                        New_Line (featuresFile);
                        Put (featuresFile, "| Lv | Feature(s)");
                        New_Line(featuresFile);
                        Put (featuresFile, TABLE_BORDER);
                        New_Line(featuresFile);
                        If character.class.level >= 1 Then
                              -- print out 1st lev class features
                              Ada.Text_IO.Put(featuresFile, "|  1 | Spellcasting");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Divine Domain");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Bonus Proficiency");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Disciple of Life");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 2 Then
                              -- print out 1st and 2nd lev class features
                              Ada.Text_IO.Put(featuresFile, "|  2 | Channel Divinity (1/rest)");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Channel Divinity: Preserve Life");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 3 Then
                              -- print out 1st, 2nd, and 3rd lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  3 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 4 Then
                              -- print out 1st thru 4th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  4 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 5 Then
                              -- print out 1st thru 5th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  5 | Destroy Undead (CR < 1/2)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 6 Then
                              -- print out 1st thru 6th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  6 | Channel Divinity (2/rest)");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Blessed Healer");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 7 Then
                              -- print out 1st thru 7th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  7 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 8 Then
                              -- print out 1st thru 8th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  8 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Destroy Undead (CR < 1)");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Divine Strike");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 9 Then
                              -- print out 1st thru 9th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  9 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 10 Then
                              -- print out 1st thru 10th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 10 | Divine Intervention");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 11 Then
                              -- print out 1st thru 11th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 11 | Destroy Undead (CR < 2)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 12 Then
                              -- print out 1st thru 12th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 12 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 13 Then
                              -- print out 1st thru 13th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 13 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 14 Then
                              -- print out 1st thru 14th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 14 | Destroy Undead (CR < 3)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 15 Then
                              -- print out 1st thru 15th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 15 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 16 Then
                              -- print out 1st thru 16th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 16 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 17 Then
                              -- print out 1st thru 17th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 17 | Destroy Undead (CR < 4)");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Supreme Healing");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 18 Then
                              -- print out 1st thru 18th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 18 | Channel Divinity (3/rest)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 19 Then
                              -- print out 1st thru 19th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 19 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 20 Then
                              -- print out 1st thru 20th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 20 | Divine Intervention Improvement");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                  End If;
            When Druid =>
                  If character.class.subclass = Land Then
                        Put (featuresFile, character.class.main);
                        Put (featuresFile, " - CIRCLE OF THE ");
                        Put (featuresFile, character.class.subclass);
                        New_Line(featuresFile);
                        Put (featuresFile, "---------------------------------------");
                        New_Line(featuresFile);
                        Put (featuresFile, "| Lv | Feature(s)");
                        New_Line(featuresFile);
                        Put (featuresFile, TABLE_BORDER);
                        New_Line(featuresFile);
                        If character.class.level >= 1 Then
                              Put (featuresFile, "|  1 | Druidic");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Spellcasting");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 2 Then
                              Put (featuresFile, "|  2 | Wild Shape");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Druid Circle");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Bonus Cantrip");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Natural Recovery");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 3 Then
                              Put (featuresFile, "|  3 | Circle Spells");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 4 Then
                              Put (featuresFile, "|  4 | Wild Shape Improvement");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 5 Then
                              Put (featuresFile, "|  5 | Circle Spells");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 6 Then
                              Put (featuresFile, "|  6 | Land's Stride");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 7 Then
                              Put (featuresFile, "|  7 | Circle Spells");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 8 Then
                              Put (featuresFile, "|  8 | Wild Shape Improvement");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 9 Then
                              Put (featuresFile, "|  9 | Circle Spells");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 10 Then
                              Put (featuresFile, "| 10 | Nature's Ward");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 11 Then
                              Put (featuresFile, "| 11 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 12 Then
                              Put (featuresFile, "| 12 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 13 Then
                              Put (featuresFile, "| 13 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 14 Then
                              Put (featuresFile, "| 14 | Nature's Sanctuary");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 15 Then
                              Put (featuresFile, "| 15 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 16 Then
                              Put (featuresFile, "| 16 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 17 Then
                              Put (featuresFile, "| 17 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 18 Then
                              Put (featuresFile, "| 18 | Timeless Body");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Beast Spells");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 19 Then
                              Put (featuresFile, "| 19 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 20 Then
                              Put (featuresFile, "| 20 | Archdruid");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                  End If;
            When Fighter =>
                  If character.class.subclass = champion Then
                        Put (featuresFile, character.class.main);
                        Put (featuresFile, " - ");
                        Put (featuresFile, character.class.subclass);
                        Put (featuresFile, " ARCHETYPE");
                        New_Line(featuresFile);
                        Put (featuresFile, "---------------------------------------");
                        New_Line (featuresFile);
                        Put (featuresFile, "| Lv | Feature(s)");
                        New_Line(featuresFile);
                        Put (featuresFile, TABLE_BORDER);
                        New_Line(featuresFile);
                        If character.class.level >= 1 Then
                              -- print out 1st lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  1 | Fighting Style");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Second Wind");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 2 Then
                              -- print out 1st and 2nd lev class features
                              Ada.Text_IO.Put(featuresFile, "|  2 | Action Surge (1 Use)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 3 Then
                              -- print out 1st, 2nd, and 3rd lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  3 | Martial Archetype");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Improved Critical");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 4 Then
                              -- print out 1st thru 4th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  4 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 5 Then
                              -- print out 1st thru 5th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  5 | Extra Attack (1)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 6 Then
                              -- print out 1st thru 6th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  6 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 7 Then
                              -- print out 1st thru 7th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  7 | Remarkable Athlete");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 8 Then
                              -- print out 1st thru 8th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  8 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 9 Then
                              -- print out 1st thru 9th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  9 | Indomitable (1 Use)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 10 Then
                              -- print out 1st thru 10th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 10 | Additional Fighting Style");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 11 Then
                              -- print out 1st thru 11th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 11 | Extra Attack (2)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 12 Then
                              -- print out 1st thru 12th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 12 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 13 Then
                              -- print out 1st thru 13th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 13 | Indomitable (2 Uses)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 14 Then
                              -- print out 1st thru 14th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 14 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 15 Then
                              -- print out 1st thru 15th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 15 | Superior Critical");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 16 Then
                              -- print out 1st thru 16th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 16 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 17 Then
                              -- print out 1st thru 17th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 17 | Action Surge (2 Uses)");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Indomitable (3 Uses)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 18 Then
                              -- print out 1st thru 18th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 18 | Survivor");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 19 Then
                              -- print out 1st thru 19th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 19 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 20 Then
                              -- print out 1st thru 20th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 20 | Extra Attack (3)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                  End If;
            When Monk =>
                  If character.class.subclass = OpenHand Then
                        Put (featuresFile, character.class.main);
                        Put (featuresFile, " - WAY OF THE OPEN HAND");
                        New_Line(featuresFile);
                        Put (featuresFile, "---------------------------------------");
                        New_Line(featuresFile);
                        Put (featuresFile, "| Lv | Feature(s)");
                        New_Line(featuresFile);
                        Put (featuresFile, TABLE_BORDER);
                        New_Line(featuresFile);
                        If character.class.level >= 1 Then
                              Put (featuresFile, "|  1 | Unarmored Defense");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Martial Arts");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 2 Then
                              Put (featuresFile, "|  2 | Ki");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Unarmored Movement");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 3 Then
                              Put (featuresFile, "|  3 | Monastic Tradition");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Deflect Missiles");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 4 Then
                              Put (featuresFile, "|  4 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Slow Fall");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 5 Then
                              Put (featuresFile, "|  5 | Extra Attack");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Stunning Strike");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 6 Then
                              Put (featuresFile, "|  6 | Ki-Empowered Strikes");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Wholeness of Body");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 7 Then
                              Put (featuresFile, "|  7 | Evasion");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Stillness of Mind");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 8 Then
                              Put (featuresFile, "|  8 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 9 Then
                              Put (featuresFile, "|  9 | Unarmored Movement Improvement");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 10 Then
                              Put (featuresFile, "| 10 | Purity of Body");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 11 Then
                              Put (featuresFile, "| 11 | Tranquility");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 12 Then
                              Put (featuresFile, "| 12 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 13 Then
                              Put (featuresFile, "| 13 | Tongue of the Sun and Moon");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 14 Then
                              Put (featuresFile, "| 14 | Diamond Soul");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 15 Then
                              Put (featuresFile, "| 15 | Timeless Body");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 16 Then
                              Put (featuresFile, "| 16 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 17 Then
                              Put (featuresFile, "| 17 | Quivering Palm");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 18 Then
                              Put (featuresFile, "| 18 | Empty Body");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 19 Then
                              Put (featuresFile, "| 19 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 20 Then
                              Put (featuresFile, "| 20 | Perfect Self");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                  End If;
            When Paladin =>
                  If character.class.subclass = Devotion Then
                        Put (featuresFile, character.class.main);
                        Put (featuresFile, " - OATH OF ");
                        Put (featuresFile, character.class.subclass);
                        New_Line(featuresFile);
                        Put (featuresFile, "---------------------------------------");
                        New_Line(featuresFile);
                        Put (featuresFile, "| Lv | Feature(s)");
                        New_Line(featuresFile);
                        Put (featuresFile, TABLE_BORDER);
                        New_Line(featuresFile);
                        If character.class.level >= 1 Then
                              Put (featuresFile, "|  1 | Divine Sense");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Lay on Hands");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 2 Then
                              Put (featuresFile, "|  2 | Fighting Style");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Spellcasting");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Divine Smite");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 3 Then
                              Put (featuresFile, "|  3 | Divine Helath");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Sacred Oath");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Oath Spells");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Channel Divinity");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 4 Then
                              Put (featuresFile, "|  4 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 5 Then
                              Put (featuresFile, "|  5 | Extra Attack");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 6 Then
                              Put (featuresFile, "|  6 | Aura of Protection (10 ft)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 7 Then
                              Put (featuresFile, "|  7 | Aura of Devotion (10 ft)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 8 Then
                              Put (featuresFile, "|  8 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 9 Then
                              Put (featuresFile, "|  9 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 10 Then
                              Put (featuresFile, "| 10 | Aura of Courage (10 ft)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 11 Then
                              Put (featuresFile, "| 11 | Improved Divine Smite");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 12 Then
                              Put (featuresFile, "| 12 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 13 Then
                              Put (featuresFile, "| 13 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 14 Then
                              Put (featuresFile, "| 14 | Cleansing Touch");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 15 Then
                              Put (featuresFile, "| 15 | Purity of Spirit");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 16 Then
                              Put (featuresFile, "| 16 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 17 Then
                              Put (featuresFile, "| 17 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 18 Then
                              Put (featuresFile, "| 18 | Aura Improvements (30 ft)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 19 Then
                              Put (featuresFile, "| 19 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 20 Then
                              Put (featuresFile, "| 20 | Holy Nimbus");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                  End If;
            When Ranger =>
                  If character.class.subclass = Hunter Then
                        Put (featuresFile, character.class.main);
                        Put (featuresFile, " - ");
                        Put (featuresFile, character.class.subclass);
                        New_Line(featuresFile);
                        Put (featuresFile, "---------------------------------------");
                        New_Line(featuresFile);
                        Put (featuresFile, "| Lv | Feature(s)");
                        New_Line(featuresFile);
                        Put (featuresFile, TABLE_BORDER);
                        New_Line(featuresFile);
                        If character.class.level >= 1 Then
                              Put (featuresFile, "|  1 | Favored Enemy");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Natural Explorer");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 2 Then
                              Put (featuresFile, "|  2 | Fighting Style");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Spellcasting");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 3 Then
                              Put (featuresFile, "|  3 | Ranger Archetype");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Primeval Awareness");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Hunter's Prey");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 4 Then
                              Put (featuresFile, "|  4 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 5 Then
                              Put (featuresFile, "|  5 | Extra Attack");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 6 Then
                              Put (featuresFile, "|  6 | Favored Enemy Improvement");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Natural Explorer Improvement");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 7 Then
                              Put (featuresFile, "|  7 | Defensive Tactics");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 8 Then
                              Put (featuresFile, "|  8 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Land's Stride");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 9 Then
                              Put (featuresFile, "|  9 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 10 Then
                              Put (featuresFile, "| 10 | Natural explorer Improvement");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Hide in Plain Sight");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 11 Then
                              Put (featuresFile, "| 11 | Multiattack");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 12 Then
                              Put (featuresFile, "| 12 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 13 Then
                              Put (featuresFile, "| 13 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 14 Then
                              Put (featuresFile, "| 14 | Favored Enemy Improvement");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Vanish");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 15 Then
                              Put (featuresFile, "| 15 | Superior Hunter's Defense");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 16 Then
                              Put (featuresFile, "| 16 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 17 Then
                              Put (featuresFile, "| 17 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 18 Then
                              Put (featuresFile, "| 18 | Feral Senses");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 19 Then
                              Put (featuresFile, "| 19 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 20 Then
                              Put (featuresFile, "| 20 | Foe Slayer");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                  End If;
            When Rogue =>
                  If character.class.subclass = thief Then
                        Put (featuresFile, character.class.main);
                        Put (featuresFile, " - ");
                        Put (featuresFile, character.class.subclass);
                        Put (featuresFile, " ARCHETYPE");
                        New_Line(featuresFile);
                        Put (featuresFile, "---------------------------------------");
                        New_Line (featuresFile);
                        Put (featuresFile, "| Lv | Feature(s)");
                        New_Line(featuresFile);
                        Put (featuresFile, TABLE_BORDER);
                        New_Line(featuresFile);
                        If character.class.level >= 1 Then
                              -- print out 1st lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  1 | Expertise");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Sneak Attack");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Thieves' Cant");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 2 Then
                              -- print out 1st and 2nd lev class features
                              Ada.Text_IO.Put(featuresFile, "|  2 | Cunning Action");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 3 Then
                              -- print out 1st, 2nd, and 3rd lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  3 | Roguish Archetype");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Fast Hands");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Second-Story Work");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 4 Then
                              -- print out 1st thru 4th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  4 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 5 Then
                              -- print out 1st thru 5th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  5 | Uncanny Dodge");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 6 Then
                              -- print out 1st thru 6th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  6 | Expertise");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 7 Then
                              -- print out 1st thru 7th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  7 | Evasion");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 8 Then
                              -- print out 1st thru 8th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  8 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 9 Then
                              -- print out 1st thru 9th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  9 | Supreme Sneak");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 10 Then
                              -- print out 1st thru 10th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 10 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 11 Then
                              -- print out 1st thru 11th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 11 | Reliable Talent");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 12 Then
                              -- print out 1st thru 12th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 12 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 13 Then
                              -- print out 1st thru 13th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 13 | Use Magic Device");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 14 Then
                              -- print out 1st thru 14th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 14 | Blindsense");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 15 Then
                              -- print out 1st thru 15th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 15 | Slippery Mind");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 16 Then
                              -- print out 1st thru 16th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 16 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 17 Then
                              -- print out 1st thru 17th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 17 | Thief's Reflexes");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 18 Then
                              -- print out 1st thru 18th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 18 | Elusive");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 19 Then
                              -- print out 1st thru 19th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 19 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 20 Then
                              -- print out 1st thru 20th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 20 | Stroke of Luck");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                  End If;
            When Sorcerer =>
                  If character.class.subclass = Draconic Then
                        Put (featuresFile, character.class.main);
                        Put (featuresFile, " - ");
                        Put (featuresFile, character.class.subclass);
                        Put (featuresFile, " BLOODLINES");
                        New_Line(featuresFile);
                        Put (featuresFile, "---------------------------------------");
                        New_Line(featuresFile);
                        Put (featuresFile, "| Lv | Feature(s)");
                        New_Line(featuresFile);
                        Put (featuresFile, TABLE_BORDER);
                        New_Line(featuresFile);
                        If character.class.level >= 1 Then
                              Put (featuresFile, "|  1 | Spellcasting");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Sorcerous Origins");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Dragon Ancestor");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Draconic Resilience");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 2 Then
                              Put (featuresFile, "|  2 | Font of Magic");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 3 Then
                              Put (featuresFile, "|  3 | Metamagic");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 4 Then
                              Put (featuresFile, "|  4 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 5 Then
                              Put (featuresFile, "|  5 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 6 Then
                              Put (featuresFile, "|  6 | Elemental affinity");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 7 Then
                              Put (featuresFile, "|  7 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 8 Then
                              Put (featuresFile, "|  8 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 9 Then
                              Put (featuresFile, "|  9 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 10 Then
                              Put (featuresFile, "| 10 | Metamagic");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 11 Then
                              Put (featuresFile, "| 11 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 12 Then
                              Put (featuresFile, "| 12 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 13 Then
                              Put (featuresFile, "| 13 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 14 Then
                              Put (featuresFile, "| 14 | Dragon Wings");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 15 Then
                              Put (featuresFile, "| 15 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 16 Then
                              Put (featuresFile, "| 16 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 17 Then
                              Put (featuresFile, "| 17 | Metamagic");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 18 Then
                              Put (featuresFile, "| 18 | Draconic Presence");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 19 Then
                              Put (featuresFile, "| 19 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 20 Then
                              Put (featuresFile, "| 20 | Sorcerous Restoration");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                  End If;
            When Warlock =>
                  If character.class.subclass = Fiend Then
                        Put (featuresFile, character.class.main);
                        Put (featuresFile, " - PACT OF THE ");
                        Put (featuresFile, character.class.subclass);
                        New_Line(featuresFile);
                        Put (featuresFile, "---------------------------------------");
                        New_Line(featuresFile);
                        Put (featuresFile, "| Lv | Feature(s)");
                        New_Line(featuresFile);
                        Put (featuresFile, TABLE_BORDER);
                        New_Line(featuresFile);
                        If character.class.level >= 1 Then
                              Put (featuresFile, "|  1 | Otherworldly Patron");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Pact magic");
                              New_Line(featuresFile);
                              Put (featuresFile, "|    | Dark One's Own Blessing");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 2 Then
                              Put (featuresFile, "|  2 | Eldritch Invocations");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 3 Then
                              Put (featuresFile, "|  3 | Pact Boon");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 4 Then
                              Put (featuresFile, "|  4 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 5 Then
                              Put (featuresFile, "|  5 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 6 Then
                              Put (featuresFile, "|  6 | Dark One's Own Luck");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 7 Then
                              Put (featuresFile, "|  7 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 8 Then
                              Put (featuresFile, "|  8 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 9 Then
                              Put (featuresFile, "|  9 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 10 Then
                              Put (featuresFile, "| 10 | Fiendish Resilience");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 11 Then
                              Put (featuresFile, "| 11 | Mystic Arcaneum (6th level)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 12 Then
                              Put (featuresFile, "| 12 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 13 Then
                              Put (featuresFile, "| 13 | Mystic Arcaneum (7th level)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 14 Then
                              Put (featuresFile, "| 14 | Hurl through Hell");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 15 Then
                              Put (featuresFile, "| 15 | Mystic Arcaneum (8th level)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 16 Then
                              Put (featuresFile, "| 16 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 17 Then
                              Put (featuresFile, "| 17 | Mystic Arcaneum (9th level)");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 18 Then
                              Put (featuresFile, "| 18 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 19 Then
                              Put (featuresFile, "| 19 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 20 Then
                              Put (featuresFile, "| 20 | Eldritch Master");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                  End If;
            When Wizard =>
                  If character.class.subclass = Evocation Then
                        Put (featuresFile, character.class.main);
                        Put (featuresFile, " - SCHOOL OF ");
                        Put (featuresFile, character.class.subclass);
                        New_Line(featuresFile);
                        Put (featuresFile, "---------------------------------------");
                        New_Line (featuresFile);
                        Put (featuresFile, "| Lv | Feature(s)");
                        New_Line(featuresFile);
                        Put (featuresFile, TABLE_BORDER);
                        New_Line(featuresFile);
                        If character.class.level >= 1 Then
                              -- print out 1st lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  1 | Spellcasting");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Arcane Recovery");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 2 Then
                              -- print out 1st and 2nd lev class features
                              Ada.Text_IO.Put(featuresFile, "|  2 | Arcane Tradition");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Evocation Savant");
                              New_Line(featuresFile);
                              Ada.Text_IO.Put(featuresFile, "|    | Sculpt Spells");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 3 Then
                              -- print out 1st, 2nd, and 3rd lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  3 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 4 Then
                              -- print out 1st thru 4th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  4 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 5 Then
                              -- print out 1st thru 5th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  5 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 6 Then
                              -- print out 1st thru 6th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  6 | Potent Cantrip");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 7 Then
                              -- print out 1st thru 7th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  7 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 8 Then
                              -- print out 1st thru 8th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  8 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 9 Then
                              -- print out 1st thru 9th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "|  9 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 10 Then
                              -- print out 1st thru 10th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 10 | Empowered Evocation");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 11 Then
                              -- print out 1st thru 11th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 11 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 12 Then
                              -- print out 1st thru 12th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 12 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 13 Then
                              -- print out 1st thru 13th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 13 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 14 Then
                              -- print out 1st thru 14th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 14 | Overchannel");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 15 Then
                              -- print out 1st thru 15th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 15 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 16 Then
                              -- print out 1st thru 16th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 16 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 17 Then
                              -- print out 1st thru 17th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 17 | ---");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 18 Then
                              -- print out 1st thru 18th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 18 | Spell Mastery");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 19 Then
                              -- print out 1st thru 19th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 19 | Ability Score Improvement*");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                        If character.class.level >= 20 Then
                              -- print out 1st thru 20th lev class and sub features
                              Ada.Text_IO.Put(featuresFile, "| 20 | Signature Spell");
                              New_Line(featuresFile);
                              Put (featuresFile, TABLE_BORDER);
                              New_Line(featuresFile);
                        End If;
                  End If;
            When others => null;
      End Case;
      Put(featuresFile, "* You must manually modify ability scores.");
      New_Line(featuresFile);
      Put(featuresFile, "  You have 2 points to allocate and scores cannot exceed 20.");
      New_Line(featuresFile);
      close(featuresFile);

End outputFeatures;

----------------------------------------------------
--------Declaration Section of the main body--------
----------------------------------------------------
   escape : Character;
   character : Character_Type;

Begin -- NPC_Builder

   getUserInput (character);
   New_Line;

   caseRaceInfo(character);
   caseAbilityScores(character);
   If character.race.main = HalfElf Then
      halfElfAbilities(character);
      caseAbilityScores(character);
   End If;
   caseClassInfo(character);
   combatReference(character);
   New_Line;
   outputToConsole(character);
   outputCharacterFile(character);
   outputSkillsToFile(character);
   outputCombatReference(character);
   outputFeatures(character);

   New_Line;
   Put ("Check out the area you saved this program");
   New_Line;
   Put ("to find text file versions of the output.");
   New_Line;
   Put ("The files will be named:");
   New_Line;
   Put ("1.) 'Character.txt.'");
   New_Line;
   Put ("2.) 'Skills.txt'");
   New_Line;
   Put ("3.) 'CombatReference.txt'");
   New_Line;
   Put ("4.) 'Features.txt'");

   New_Line(2);
   Put("Press any key to terminate the program. ");
   Ada.Text_IO.Get_Immediate(escape);

End NPC_Builder;
