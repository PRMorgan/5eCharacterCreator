-- This is a personal project that was conceived
-- from a lack of really quick Dungeons and
-- Dragons character creation tools.

-- The only content supported in this tool
-- is that which can be found in the
-- Systems Reference Document (SRD)
-- from Wizards of the Coast.

-- All information found in here is the
-- intellectual property of
-- Wizards of the Coast.
-- I do not own the rights to any of the
-- content found hereafter.

-- Created by Patrick M
-- Start Date: 8 March 2018
-- Last Update: 24 April 2018

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

   Type Class_List is (Cleric, Fighter, Rogue, Wizard);
   Package Class_IO is new Ada.Text_IO.Enumeration_IO (Class_List);
   Use Class_IO;

   Type Subclass_List is (Life, Champion, Thief, Evocation);
   Package Subclass_IO is new Ada.Text_IO.Enumeration_IO (Subclass_List);
   Use Subclass_IO;

   Type Race_List is (Dwarf, Elf, Halfling, Human);
   Package Race_IO is new Ada.Text_IO.Enumeration_IO (Race_List);
   Use Race_IO;

   Type Subrace_List is (Hill, Mountain, High, Wood, Lightfoot, Stout,
                         Calishite, Chondathan, Damaran, Illuskan,
                         Mulan, Rashemi, Shou, Tethyrian, Turami);
   Package Subrace_IO is new Ada.Text_IO.Enumeration_IO (Subrace_List);
   Use Subrace_IO;

   Type Skills_List is (Acrobatics, Animal_Handling, Arcana, Athletics, Deception, History,
		            Insight, Intimidation, Investigation, Medicine, Nature, Perception,
		            Performance, Persuasion, Religion, Sleight_Of_Hand, Stealth, Survival);
   Package Skills_IO is new Ada.Text_IO.Enumeration_IO (Skills_List);
   Use Skills_IO;

   Type Ability_Scores_List is (STR, DEX, CON, INT, WIS, CHA, NA);
   Package Stats_IO is new Ada.Text_IO.Enumeration_IO (Ability_Scores_List);
   Use Stats_IO;

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

--Subprograms
   Procedure getUserInput(character  : out Character_Type) is

      levelFlag   : Boolean := True;
      profFlag    : Boolean := True;
      scoresFlag  : Boolean := True;
      subraceFlag : Boolean := True;

   Begin -- getUserInput

      Put ("Enter the character's name: ");
      New_Line;
      Put (">>> ");
      Get_Line(character.name.name, character.name.length);
      New_Line;


      Put ("Choose your character's race from the following list:");
      New_Line;
      Put ("Dwarf, Elf, Halfling, Human: ");
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
                        Put ("Dwarf, Elf, Halfling, or Human?");
                        Skip_Line;
            End raceInputBlock;
      End loop validRaceLoop;
      --------Data Validation Loop--------
      New_Line;

      Case character.race.main is
      When Dwarf     => Put ("Choose your character's Subrace from the following list:");
                        While subraceFlag Loop
                              New_Line;
                              Put ("Hill or Mountain");
                              validDwarfLoop:
                              Loop
                                    dwarfInputBlock:
                                    begin
                                          New_Line;
                                          Put (">>> ");
                                          Subrace_IO.Get (character.race.subrace);
                                          If character.race.subrace = Hill Then
                                                subraceFlag := False;
                                          Elsif character.race.subrace = Mountain Then
                                                subraceFlag := False;
                                          Else
                                                subraceFlag := True;
                                          End If;
                                          exit validDwarfLoop;
                                    exception
                                          When Ada.Text_IO.DATA_ERROR =>
                                                New_Line;
                                                Put ("Hill or Mountain");
                                                Skip_Line;
                                    End dwarfInputBlock;
                              End loop validDwarfLoop;
                        End Loop;
      When Elf       => Put ("Choose your character's Subrace from the following list:");
                        While subraceFlag loop
                              New_Line;
                              Put ("High or Wood");
                              validElfLoop:
                              Loop
                                    elfInputBlock:
                                    begin
                                          New_Line;
                                          Put (">>> ");
                                          Subrace_IO.Get (character.race.subrace);
                                          If character.race.subrace = High Then
                                                subraceFlag := False;
                                          Elsif character.race.subrace = Wood Then
                                                subraceFlag := False;
                                          Else
                                                subraceFlag := True;
                                          End If;
                                          exit validElfLoop;
                                    exception
                                          When Ada.Text_IO.DATA_ERROR =>
                                                New_Line;
                                                Put ("High or Wood");
                                                Skip_Line;
                                    End elfInputBlock;
                              End Loop validElfLoop;
                        End Loop;
      When Halfling  => Put ("Choose your character's Subrace from the following list:");
                        While subraceFlag Loop
                              New_Line;
                              Put ("Lightfoot or Stout");
                              validHalflingLoop:
                              Loop
                                    halflingInputBlock:
                                    begin
                                          New_Line;
                                          Put (">>> ");
                                          Subrace_IO.Get (character.race.subrace);
                                          If character.race.subrace = Lightfoot Then
                                                subraceFlag := False;
                                          Elsif character.race.subrace = Stout Then
                                                subraceFlag := False;
                                          Else
                                                subraceFlag := True;
                                          End If;
                                          exit validHalflingLoop;
                                    exception
                                          When Ada.Text_IO.DATA_ERROR =>
                                                New_Line;
                                                Put ("Lightfoot or Stout");
                                                Skip_Line;
                                    End halflingInputBlock;
                              End Loop validHalflingLoop;
                        End Loop;
      When Human     => Put ("Choose your character's Subrace from the following list:");
                        While subraceFlag Loop
                              New_Line;
                              Put ("Calishite, Chondathan, Damaran, Illuskan, Mulan,");
                              New_Line;
                              Put ("Rashemi, Shou, Tethyrian, or Turami");
                              validHumanLoop:
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
      End Case;
      New_Line;

      Put ("Choose your character's class from the following list:");
      New_Line;
      Put ("Cleric, Fighter, Rogue, Wizard: ");
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
                        Put ("Cleric, Fighter, Rogue, or Wizard?");
                        Skip_Line;
            End classInputBlock;
      End Loop validClassLoop;
      --------Data Validation Loop--------

      Case character.class.main is
         When Cleric  => character.class.subclass := Life;
         When Fighter => character.class.subclass := Champion;
         When Rogue   => character.class.subclass := Thief;
         When Wizard  => character.class.subclass := Evocation;
      End Case;
      New_Line;

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

      Case character.class.main is
         When Cleric  => character.class.hitDice := 8;
         When Fighter => character.class.hitDice := 10;
         When Rogue   => character.class.hitDice := 8;
         When Wizard  => character.class.hitDice := 6;
      End Case;

      Case character.class.main is
            When Cleric  => Put ("You can choose 2 skill proficiencies from the following list:");
                        New_Line;
                        Put ("(Please enter one skill per line)");
                        New_Line;
                        Put ("History, Insight, Medicine, Persuasion, Religion");
                        New_Line;
            When Fighter => Put ("You can choose 2 skill proficiencies from the following list:");
                        New_Line;
                        Put ("Acrobatics, Animal_Handling, Athletics, History, Insight,");
                        New_Line;
                        Put ("Intimidation, Perception, Survival");
                        New_Line;
            When Rogue   => Put ("You can choose 4 skill proficiencies from the following list:");
                        New_Line;
                        Put ("Acrobatics, Athletics, Deception, Insight, Intimidation,");
                        New_Line;
                        Put ("Investigation, Perception, Persuasion, Sleight_of_Hand, Stealth");
                        New_Line;
                        numSkillProfs := 4;
            When Wizard  => Put ("You can choose 2 skill proficiencies from the following list:");
                        New_Line;
                        Put ("Arcana, History, Insight, Investigation, Medicine, Religion");
                        New_Line;
      End Case;

      If character.class.main = Rogue Then
            numSkillProfs := 4;
      Else
           numSkillProfs := 2;
      End If;

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

      Case character.race.main is
         When Dwarf    => character.race.speed := 25;
                          character.race.size := 'M';
                          character.stat.CON.base := character.stat.CON.base +2;
         When Elf      => character.race.speed := 30;
            If character.race.subrace = High Then
               character.race.speed := 35;
            End if;
                          character.race.size := 'M';
                          character.stat.DEX.base := character.stat.DEX.base +2;
         When Halfling => character.race.speed := 25;
                          character.race.size := 'S';
                          character.stat.DEX.base := character.stat.DEX.base +2;
         When Human    => character.race.speed := 30;
                          character.race.size := 'M';
                          character.stat.STR.base := character.stat.STR.base +1;
                          character.stat.DEX.base := character.stat.DEX.base +1;
                          character.stat.CON.base := character.stat.CON.base +1;
                          character.stat.INT.base := character.stat.INT.base +1;
                          character.stat.WIS.base := character.stat.WIS.base +1;
                          character.stat.CHA.base := character.stat.CHA.base +1;
      End Case;

      Case character.race.subrace is
         When Hill      => character.stat.WIS.base := character.stat.WIS.base +1;
         When Mountain  => character.stat.STR.base := character.stat.STR.base +1;
         When High      => character.stat.INT.base := character.stat.INT.base +1;
         When Wood      => character.stat.WIS.base := character.stat.WIS.base +1;
         When Lightfoot => character.stat.CHA.base := character.stat.CHA.base +1;
         When Stout     => character.stat.CON.base := character.stat.CON.base +1;
         When others    => null;
      End Case;

   End caseRaceInfo;

------------------------------------------------------------
   Procedure combatReference (character : in out Character_Type) is

      spellDCBase : Integer;

   Begin --combatReference

      -- Physical combat information
      character.combat.STRbased := character.stat.STR.modifier;
      character.combat.STRproficient :=
            character.stat.STR.modifier + character.class.proficiency;

      character.combat.DEXbased := character.stat.DEX.modifier;
      character.combat.DEXproficient :=
            character.stat.DEX.modifier + character.class.proficiency;

      character.combat.unarmedAttack :=
            character.stat.STR.modifier + character.class.proficiency;

      -- Spellcasting Information
      spellDCBase := 8 + character.class.proficiency;
      Case character.class.main is
            When Cleric => character.combat.spellDC :=
                              spellDCBase + character.stat.WIS.modifier;
                           character.combat.spellAttack :=
                              character.class.proficiency + character.stat.WIS.modifier;
                           character.combat.spellStat := WIS;
            When Wizard => character.combat.spellDC :=
                              spellDCBase + character.stat.INT.modifier;
                           character.combat.spellAttack :=
                              character.class.proficiency + character.stat.INT.modifier;
                           character.combat.spellStat := INT;
            When others => character.combat.spellDC := -99;
                           character.combat.spellAttack := -99;
                           character.combat.spellStat := NA;
      End Case;

      --Hard Coded:
      --    Damage Die
      --    Classification (simple/martial)
      --    Damage Ability Score
      --    Name string
      --    Name length integer
      character.combat.attack(Battleaxe).die := 8;
      character.combat.attack(Battleaxe).classification := Martial;
      character.combat.attack(Battleaxe).damageAbility := STR;
      character.combat.attack(Battleaxe).name := "Battleaxe     ";
      character.combat.attack(Battleaxe).nameLength := 9;
      character.combat.attack(Blowgun).die := 1;
      character.combat.attack(Blowgun).classification := Martial;
      character.combat.attack(Blowgun).damageAbility := DEX;
      character.combat.attack(Blowgun).name := "Blowgun       ";
      character.combat.attack(Blowgun).nameLength := 7;
      character.combat.attack(Club).die := 4;
      character.combat.attack(Club).classification := Simple;
      character.combat.attack(Club).damageAbility := STR;
      character.combat.attack(Club).name := "Club          ";
      character.combat.attack(Club).nameLength := 4;
      character.combat.attack(Dagger).die := 4;
      character.combat.attack(Dagger).classification := Simple;
      character.combat.attack(Dagger).damageAbility := STR;
      character.combat.attack(Dagger).name := "Dagger        ";
      character.combat.attack(Dagger).nameLength := 6;
      character.combat.attack(Dart).die := 4;
      character.combat.attack(Dart).classification := Simple;
      character.combat.attack(Dart).damageAbility := DEX;
      character.combat.attack(Dart).name := "Dart          ";
      character.combat.attack(Dart).nameLength := 4;
      character.combat.attack(Flail).die := 8;
      character.combat.attack(Flail).classification := Martial;
      character.combat.attack(Flail).damageAbility := STR;
      character.combat.attack(Flail).name := "Flail         ";
      character.combat.attack(Flail).nameLength := 5;
      character.combat.attack(Glaive).die := 10;
      character.combat.attack(Glaive).classification := Martial;
      character.combat.attack(Glaive).damageAbility := STR;
      character.combat.attack(Glaive).name := "Glaive        ";
      character.combat.attack(Glaive).nameLength := 6;
      character.combat.attack(Greatclub).die := 8;
      character.combat.attack(Greatclub).classification := Simple;
      character.combat.attack(Greatclub).damageAbility := STR;
      character.combat.attack(Greatclub).name := "Greatclub     ";
      character.combat.attack(Greatclub).nameLength := 9;
      character.combat.attack(Greatsword).die := 6;
      character.combat.attack(Greatsword).classification := Martial;
      character.combat.attack(Greatsword).damageAbility := STR;
      character.combat.attack(Greatsword).name := "Greatsword    ";
      character.combat.attack(Greatsword).nameLength := 10;
      character.combat.attack(Halberd).die := 10;
      character.combat.attack(Halberd).classification := Martial;
      character.combat.attack(Halberd).damageAbility := STR;
      character.combat.attack(Halberd).name := "Halberd       ";
      character.combat.attack(Halberd).nameLength := 7;
      character.combat.attack(Handaxe).die := 6;
      character.combat.attack(Handaxe).classification := Simple;
      character.combat.attack(Handaxe).damageAbility := STR;
      character.combat.attack(Handaxe).name := "Handaxe       ";
      character.combat.attack(Handaxe).nameLength := 7;
      character.combat.attack(HandCrossbow).die := 6;
      character.combat.attack(HandCrossbow).classification := Martial;
      character.combat.attack(HandCrossbow).damageAbility := DEX;
      character.combat.attack(HandCrossbow).name := "Hand Crossbow ";
      character.combat.attack(HandCrossbow).nameLength := 13;
      character.combat.attack(HeavyCrossbow).die := 10;
      character.combat.attack(HeavyCrossbow).classification := Martial;
      character.combat.attack(HeavyCrossbow).damageAbility := DEX;
      character.combat.attack(HeavyCrossbow).name := "Heavy Crossbow";
      character.combat.attack(HeavyCrossbow).nameLength := 14;
      character.combat.attack(Javelin).die := 6;
      character.combat.attack(Javelin).classification := Simple;
      character.combat.attack(Javelin).damageAbility := STR;
      character.combat.attack(Javelin).name := "Javelin       ";
      character.combat.attack(Javelin).nameLength := 7;
      character.combat.attack(Lance).die := 12;
      character.combat.attack(Lance).classification := Martial;
      character.combat.attack(Lance).damageAbility := STR;
      character.combat.attack(Lance).name := "Lance         ";
      character.combat.attack(Lance).nameLength := 5;
      character.combat.attack(LightCrossbow).die := 8;
      character.combat.attack(LightCrossbow).classification := Simple;
      character.combat.attack(LightCrossbow).damageAbility := DEX;
      character.combat.attack(LightCrossbow).name := "Light Crossbow";
      character.combat.attack(LightCrossbow).nameLength := 14;
      character.combat.attack(LightHammer).die := 4;
      character.combat.attack(LightHammer).classification := Simple;
      character.combat.attack(LightHammer).damageAbility := STR;
      character.combat.attack(LightHammer).name := "Light Hammer  ";
      character.combat.attack(LightHammer).nameLength := 12;
      character.combat.attack(Longbow).die := 8;
      character.combat.attack(Longbow).classification := Martial;
      character.combat.attack(Longbow).damageAbility := DEX;
      character.combat.attack(Longbow).name := "Longbow       ";
      character.combat.attack(Longbow).nameLength := 7;
      character.combat.attack(Longsword).die := 8;
      character.combat.attack(Longsword).classification := Martial;
      character.combat.attack(Longsword).damageAbility := STR;
      character.combat.attack(Longsword).name := "Longsword     ";
      character.combat.attack(Longsword).nameLength := 9;
      character.combat.attack(Mace).die := 6;
      character.combat.attack(Mace).classification := Simple;
      character.combat.attack(Mace).damageAbility := STR;
      character.combat.attack(Mace).name := "Mace          ";
      character.combat.attack(Mace).nameLength := 4;
      character.combat.attack(Maul).die := 6;
      character.combat.attack(Maul).classification := Martial;
      character.combat.attack(Maul).damageAbility := STR;
      character.combat.attack(Maul).name := "Maul          ";
      character.combat.attack(Maul).nameLength := 4;
      character.combat.attack(Morningstar).die := 8;
      character.combat.attack(Morningstar).classification := Martial;
      character.combat.attack(Morningstar).damageAbility := STR;
      character.combat.attack(Morningstar).name := "Morningstar   ";
      character.combat.attack(Morningstar).nameLength := 11;
      character.combat.attack(Net).die := 99;
      character.combat.attack(Net).classification := Martial;
      character.combat.attack(Net).damageAbility := DEX;
      character.combat.attack(Net).name := "Net           ";
      character.combat.attack(Net).nameLength := 3;
      character.combat.attack(Pike).die := 10;
      character.combat.attack(Pike).classification := Martial;
      character.combat.attack(Pike).damageAbility := STR;
      character.combat.attack(Pike).name := "Pike          ";
      character.combat.attack(Pike).nameLength := 4;
      character.combat.attack(Quarterstaff).die := 6;
      character.combat.attack(Quarterstaff).classification := Simple;
      character.combat.attack(Quarterstaff).damageAbility := STR;
      character.combat.attack(Quarterstaff).name := "Quarterstaff  ";
      character.combat.attack(Quarterstaff).nameLength := 12;
      character.combat.attack(Rapier).die := 8;
      character.combat.attack(Rapier).classification := Martial;
      character.combat.attack(Rapier).damageAbility := STR;
      character.combat.attack(Rapier).name := "Rapier        ";
      character.combat.attack(Rapier).nameLength := 6;
      character.combat.attack(Scimitar).die := 6;
      character.combat.attack(Scimitar).classification := Martial;
      character.combat.attack(Scimitar).damageAbility := STR;
      character.combat.attack(Scimitar).name := "Scimitar      ";
      character.combat.attack(Scimitar).nameLength := 8;
      character.combat.attack(Shortbow).die := 6;
      character.combat.attack(Shortbow).classification := Simple;
      character.combat.attack(Shortbow).damageAbility := DEX;
      character.combat.attack(Shortbow).name := "Shortbow      ";
      character.combat.attack(Shortbow).nameLength := 8;
      character.combat.attack(Shortsword).die := 6;
      character.combat.attack(Shortsword).classification := Martial;
      character.combat.attack(Shortsword).damageAbility := STR;
      character.combat.attack(Shortsword).name := "Shortsword    ";
      character.combat.attack(Shortsword).nameLength := 10;
      character.combat.attack(Sickle).die := 4;
      character.combat.attack(Sickle).classification := Simple;
      character.combat.attack(Sickle).damageAbility := STR;
      character.combat.attack(Sickle).name := "Sickle        ";
      character.combat.attack(Sickle).nameLength := 6;
      character.combat.attack(Sling).die := 4;
      character.combat.attack(Sling).classification := Simple;
      character.combat.attack(Sling).damageAbility := DEX;
      character.combat.attack(Sling).name := "Sling         ";
      character.combat.attack(Sling).nameLength := 5;
      character.combat.attack(Spear).die := 6;
      character.combat.attack(Spear).classification := Simple;
      character.combat.attack(Spear).damageAbility := STR;
      character.combat.attack(Spear).name := "Spear         ";
      character.combat.attack(Spear).nameLength := 5;
      character.combat.attack(Trident).die := 6;
      character.combat.attack(Trident).classification := Martial;
      character.combat.attack(Trident).damageAbility := STR;
      character.combat.attack(Trident).name := "Trident       ";
      character.combat.attack(Trident).nameLength := 7;
      character.combat.attack(Warhammer).die := 8;
      character.combat.attack(Warhammer).classification := Martial;
      character.combat.attack(Warhammer).damageAbility := STR;
      character.combat.attack(Warhammer).name := "Warhammer     ";
      character.combat.attack(Warhammer).nameLength := 9;
      character.combat.attack(Warpick).die := 8;
      character.combat.attack(Warpick).classification := Martial;
      character.combat.attack(Warpick).damageAbility := STR;
      character.combat.attack(Warpick).name := "Warpick       ";
      character.combat.attack(Warpick).nameLength := 7;
      character.combat.attack(Whip).die := 4;
      character.combat.attack(Whip).classification := Martial;
      character.combat.attack(Whip).damageAbility := STR;
      character.combat.attack(Whip).name := "Whip          ";
      character.combat.attack(Whip).nameLength := 4;

      --Assign weapon proficiencies based on class
      For i in character.combat.attack'range Loop
            If character.class.main = Cleric Then
                  If character.combat.attack(i).classification = Simple Then
                        character.combat.attack(i).proficient := True;
                  Else
                        character.combat.attack(i).proficient := False;
                  End If;
            Elsif character.class.main = Fighter Then
                  If character.combat.attack(i).classification = Simple Then
                        character.combat.attack(i).proficient := True;
                  Else
                        character.combat.attack(i).proficient := True;
                  End If;
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

   Begin --outputToConsole
      Put (THIRTY_THREE_DASHES);
      New_Line;
      Put (character.name.name (1..character.name.length));
      New_Line;
      If character.race.size = 'S' Then
            Put ("SMALL ");
      Elsif character.race.size = 'M' Then
            Put ("MEDIUM ");
      Elsif character.race.size = 'L' Then
            Put ("LARGE ");
      End IF;
      Put (character.race.subrace);
      Put (" ");
      Put (character.race.main);
      Put (" ");
      Put (character.class.main);
      Put (" (");
      Put (character.class.level, 1);
      Put (")");
      New_Line;
      Put (THIRTY_THREE_DASHES);
      New_Line;

      Put ("Total Health: ");
      Put (character.health.total, 1);
      New_Line;
      Put ("Armor Class:  ");
      Put (10 + character.stat.DEX.modifier, 2);
      Put (" (Unarmored)");
      New_Line;
      Put ("Hit Dice:   ");
      Put (character.class.level, 2);
      Put ("d");
      Put (character.class.hitDice, 1);
      New_Line;
      Put ("Speed:        ");
      Put (character.race.speed, 1);
      Put (" ft.");
      New_Line;
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
      New_Line;
   End outputToConsole;

------------------------------------------------------------

   Procedure outputCharacterFile (character : in Character_type) is
      File : File_Type;
   Begin -- outputCharacterFile

      Create (File, name => "Character.txt");
      --Open (File, Mode => In_File, name => "Character.txt");
      Put (File, character.name.name (1..character.name.length));
      New_Line (File);
      If character.race.size = 'S' Then
            Put (File, "SMALL ");
      Elsif character.race.size = 'M' Then
            Put (File, "MEDIUM ");
      Elsif character.race.size = 'L' Then
            Put (File, "LARGE ");
      End IF;
      Put (File, character.race.subrace);
      Put (File, " ");
      Put (File, character.race.main);
      Put (File, " ");
      Put (File, character.class.main);
      Put (File, " (");
      Put (File, character.class.level, 1);
      Put (File, ")");
      New_Line (File);
      Put (File, THIRTY_THREE_DASHES);
      New_Line (File);

      Put (File, "Total Health: ");
      Put (File, character.health.total, 1);
      New_Line (File);
      Put (File, "Armor Class:  ");
      Put (File, 10 + character.stat.DEX.modifier, 2);
      Put (File, " (Unarmored)");
      New_Line (File);
      Put (File, "Hit Dice:   ");
      Put (File, character.class.level, 2);
      Put (File, "d");
      Put (File, character.class.hitDice, 1);
      New_Line (File);
      Put (File, "Speed:        ");
      Put (File, character.race.speed, 1);
      Put (File, " ft.");
      New_Line (File);
      Put (File, THIRTY_THREE_DASHES);
      New_Line (File);

      Set_Col (File, 1);
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
      Put (File, "- I would recommend saving this document");
      New_Line (File);
      Put (File, "  with your character's name.");
      New_Line (File, 2);
      Put (File, "- Every time the program is executed, it");
      New_Line (File);
      Put (File, "  will write over any pre-existing characters.");
      Close (File);

   END OutputCharacterFile;

----------------------------------------------------

   Procedure outputSkillsToFile (character : in Character_type) is

      skillsFile : File_Type;

   Begin --outputSkillsToFile

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

      Case character.class.main is
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


   End outputCombatReference;

----------------------------------------------------

--Procedure outputClassFeatures (character : In Character_Type) is

--      Type Features_Array is array 1..10 of String (1..500);

--Begin

--      Case character.class.main is
--            When Cleric =>

--End outputClassFeatures;

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
   caseClassInfo(character);
   combatReference(character);
   New_Line;
   outputToConsole(character);
   outputCharacterFile(character);
   outputSkillsToFile(character);
   outputCombatReference(character);

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

   New_Line(2);
   Put("Press any key to terminate the program. ");
   Ada.Text_IO.Get_Immediate(escape);

End NPC_Builder;
