## MafiaML
MafiaManager provides the definition of MafiaML, an XML datastructure in which characters, items and events for the popular roleplaying game Mafia can be defined.
This provides a unified XML standard for sharing Mafia decks among computers.
The standard will be introduced in the following sections:
### Gameset
MafiaML defines a gameset to include the following attributes:
- gamesetid: A unique gameset id
- title: The title of the gameset
- fromPlayers: Minimum amount of players possible
- toPlayers: Maximum amount of players possible
- img:Coverimage 
- backimg: Back image of the card if available
- introtext: Introtext for the gamemaster to announce a new round
- outrotext: Outrotext for the gamemaster to announce a new round
```xml
<gameset gamesetid="56c7af97-9e68-4980-95d9-433933ff2326" title="Mafia"
fromPlayers="0" toPlayers="0" img="de_mafia" backimg="back">
    <introtext introtitle="Beginning of the night">The night falls.
    All players go to sleep.</introtext>
    <outrotext outrotitle="End of the night">A new day begins</outrotext>
</gameset>
```
The purpose of a gameset description is to describe metainformation about the set of cards being used and might be expanded in the future.
### Groups
Every game of mafia consists of at least two factions which are eager to win the game. Usually those factions consist of at least the Mafiosi and the Citizens. In MafiaML, the following information about factions in the game are defined:
- name: Name of the group
- gid: A unique group id used for the gamemaster to distinguish groups
- id: A unique internally used group id
- icon: An image file associated with the group
- canwin: Indicates if the group can win the game or if members of the group need to change to another group in order to win the game
- dietogether: Indicates if the members of the group are dying alltogether if one of their members is killed
- description: A group description stating the groups intentions during the game
```xml
     <group name="Mafiosi" gid="M" id="7000902e-499c-489c-a3c5-6a3dcd3ca621"
     icon="5e59e8af-709a-4ccd-be47-da2d8d32cc18" canwin="true" dietogether="false">
        <description>The Mafiosi win the game by killing all non-Mafiosi.</description>
    </group>
```
### Character Definition
A character in a Mafia gameset defines the role of a player in the game. Roles may or may not be called at different times during the game to execute specific abilities in order to influence the flow of the game for their own or their groups interests. New character roles are defined frequently by online Mafia communities. It is therefore important to extract key attributes which many characters have in common in order to express as many characters definitions as possible in MafiaML. In its current version the following attributes have been defined:
- cardid: A unique id for the character
- name: The character designation
- group: Reference to the Group::**gid**
- round: -1 if never called during the game, 0 if called every round, >1 if called in a particular round
- img: the image file associated with the character
- minamount: The minimum amount of characters of this kind needed in the game
- maxamount: The maximum amount of characters of this kind allowed in the game
- position: The position in the gamemaster list of to-be-called characters (-1 if not called)
- position2: A second position in the gamemaster list of to-be-called characters if needed by the characters
- extra: Defines the amount of extra characters needed in order for this character to be allowed in the game (e.g. if the character needs to choose between different roles every round)
- fixeddeath: Defines the round in which the character needs to die because of his ability (0=never)
- nopoints: Defines if the character can get points if he wins the game
- calleveryone: Defines if after the characters' death, the characters abilities require that every other character (alive or dead) needs to be called by the gamemaster (needed if the character can revive dead characters)
- winsalone: Defines if the characters wins the game alone (and therefore forms its own group)
- winningalive: The amount of points gained if the character wins alive
- winningdead: The amount of points gained if the characters' group wins and the characters is already dead
- balance: A balance value indicating a balance of good and evil characters (>0 good, <0 evil)
- description: A description of the characters function in the game for the gamemaster to read
```xml
    <Karte cardid="87d0cb39-fd39-455a-9a85-2912f52addb4" name="Barkeeper" 
    group="M" round="0" img=" " minamount="1" maxamount="1" position="2" 
    position2="-1" extra="0" fixeddeath="0" nopoints="false" calleveryone="false"
    winsalone="false" winningalive="2" winningdead="1" balance="0">
<description>The barkeeper can once prohibit an ability to be executed during the night.
He wins along with the Mafiosi.</description>
</Karte>
```
### Abilities
Abilities can by used by characters in the game in order to influence the game for their interest. Abilities are subject to specific constraints, e.g. a limit amount of uses, a specific round to use the ability, or a force to use abilities on several time occasions.
In the current version of MafiaML the following attributes have been defined:
- active: Indicates if the ability is active when the game starts (some abilities might be activated in the game by interactions with other players)
- amount: The amount of times an ability can be used
- availablefrom: The round in which the ability is ready to be used
- availableuntil: The round in which the ability cannot be used anymore (-1=infinity)
- probability: The success probability of executing the ability
- img: The image associated with the ability
- everyround: Indicates if the ability needs can be executed in every round
- concerns: The amount of characters concerned by the ability
- mustuse: Indicates if the ability has to be used when it is accessible by the player
- duration: Indicates the duration of the effects of the ability
- killing: Indicates if the ability can be used to directly kill the chosen player
- counterKilling: Indicates if the ability can be used to directly heal the chosen player
- self: Indicates if the ability can be used on the player executing the ability
- #text: A name for the ability
```xml
<abb active="true" amount="1" availablefrom="1" availableuntil="-1"
probability="100" img="jailguard" everyround="true" concerns="1"
mustuse="false" duration="1" killing="false" counterKilling="false"
self="false">Choose victim</abb>
```
### Actions
Actions are hints for the game master to explain his role when an ability is executed during the game. The gamemaster often needs to keep track of various things during the game and is often the cause of criticism if important aspects of the game have been forgotten.
In the current version of MafiaML the following attributes have been defined:
- id: An id for the action
- position: The position of the action to be executed
- round: The round in which this action is executed (0=every round)
- ondead: Indicates if the action is to be executed when the character dies
- title: The title of the action
- gamemaster: The action of the gamemaster to be taken during execution of the ability
- player: The action the player needs to do in order to execute the ability
```xml
    <actions>
        <action id="1"  position="2" round="0" ondead="false" title="Choose victim">
            <gamemaster>Note the character which cannot perform actions during the night.</gamemaster>
            <player>Point out the victim</player>
        </action>
    </actions>
```
### Items
Items can be used by players of the game in order to gain privileges during the game. In essence items grant abilities temporarily or non-temporarily to characters and may or may not be unusable after their usage.
```xml
  <item id="1" name="Hauptmannsorden"><description>Der Hauptmannsorden wird nach durchgeführter Wahl an den Hauptmann übergeben.</description></item>
  ```
### Events

### Player
```xml
    <player name="Obama" firstname="Barack" total="2">
        <game id="1" points="2" character="Detective"/>
    </player>
```    
### SaveGames
