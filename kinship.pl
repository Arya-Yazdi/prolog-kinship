/* 
Characters:
    i       -   Narrator
    jeff    -   Narrator's father
    widow   -   widow
    redhead -   widow's daughter
    bobby   -   narrator's son
    sonny   -   narrator's father's son 
*/


%%% Facts from song
male(i).
male(jeff).
male(bobby).
male(sonny).

female(widow).
female(redhead).

is_parent_of(jeff, i). % jeff is i's parent
is_parent_of(widow, redhead).
is_parent_of(i, bobby).
is_parent_of(widow, bobby).
is_parent_of(jeff, sonny).
is_parent_of(redhead, sonny).

spouse(i, widow).
spouse(widow, i).       % Needed to avoid infinite loops.
spouse(jeff, redhead).
spouse(redhead, jeff).  % Needed to avoid infinite loops.


%%% Kinship relationship rules
step_parent(X, Y) :- is_parent_of(Z, Y), spouse(X, Z), \+ is_parent_of(X, Y). % \+ is_parent_of keeps step and biological parents seperate to avoid duplicated.

% parent() will now be used instead of is_parent_of() as a generalized (step+biological) form of parenthood.
parent(X, Y) :- is_parent_of(X, Y).
parent(X, Y) :- step_parent(X, Y).

father(X, Y) :- male(X), parent(X, Y).
mother(X, Y) :- female(X), parent(X, Y).

son(X, Y) :- male(X), parent(Y, X).
son(X, Y) :- son_in_law(X, Y). % Song assumes a son-in-law is actually your son since it drops the 'step' label.
son_in_law(X, Y) :- male(X), spouse(X, Z), parent(Y, Z). % Husband of one's child.

daughter(X, Y) :- female(X), parent(Y, X).
daughter_in_law(X, Y) :-  female(X), spouse(X, Z), parent(Y, Z). % wife of one's child.

grand_parent(X, Y) :- parent(X, Z), parent(Z, Y).
grand_father(X, Y) :- male(X), parent(X, Z), parent(Z, Y).
grand_mother(X, Y) :- female(X), parent(X, Z), parent(Z, Y).

grand_child(X, Y) :- grand_parent(Y, X).

sibling(X, Y) :- parent(Z, X), parent(Z, Y), X\=Y.
isBrotherOf(X, Y) :- male(X), parent(Z, X), parent(Z, Y), X\=Y.
isSisterOf(X, Y) :- female(X), parent(Z, X), parent(Z, Y), X\=Y. % We don't need to take care of step-sister as parent() coveres step-parents.

uncle(X, Y) :- male(X), parent(Z, Y), sibling(Z, X).
aunty(X, Y) :- female(X), parent(Z, Y), sibling(Z, X).

brother_in_law(X, Y) :- spouse(Z, Y), isBrotherOf(X, Z).
sister_in_law(X, Y) :- spouse(Z, Y), isSisterOf(X, Z).

% brother() is now used as a generic form of brother, step-brother, and brother in law.
brother(X, Y) :- isBrotherOf(X, Y).
brother(X, Y) :- brother_in_law(X, Y).

% sister() is now used as a generic form of sister, step-sister, and sister in law.
sister(X, Y) :- isSisterOf(X, Y).
sister(X, Y) :- sister_in_law(X, Y).


%%% TESTS
% Test 1 - from documentation
test1 :- daughter(redhead,i), 
         mother(redhead,i), 
         son_in_law(jeff,i), 
         brother(bobby, jeff), 
         uncle(bobby,i), 
         brother(bobby,redhead), 
         grand_child(sonny,i), 
         mother(widow,redhead), 
         grand_mother(widow,i), 
         grand_child(i,widow), 
         grand_father(i,i).

% Test 2 - Song Facts
test2 :- spouse(i, widow),               % I was married to a widow
         daughter(redhead, widow),       % This widow had a grown-up daughter
         father(jeff, i),                % My father fell in love with her
         spouse(jeff, redhead),          % And soon the two were wed

         son_in_law(jeff, i),            % This made my dad my son-in-law
         daughter(redhead, i),           % For my daughter was my mother
         mother(redhead, i),   
         father(i, bobby),               % I soon became the father Of a bouncing baby boy

         brother_in_law(bobby, jeff),    % This little baby then became A brother-in-law to Dad
         uncle(bobby, i),                % And so became my uncle
         brother(bobby, redhead),        % Then that also made him brother Of the widow's grown-up daughter
         mother(redhead, i),             % Who of course is my step-mother
         
         parent(redhead, sonny),         % My father's wife then had a son
         grand_child(sonny, i),          % And he became my grandchild 
         daughter(redhead, i),           % For he was my daughter's son
         son(sonny, redhead),
         mother(widow, redhead),         % My wife is now my mother's mother 
         mother(redhead, i), 
         grand_mother(widow, i),         % She's my grandmother too

         grand_child(i, widow),          % Then I'm her grandchild
         grand_father(i, i).             % I am my own grandpa




