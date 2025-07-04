/* 
Characters:
    i       -   Narrator
    jeff    -   Narrator's father
    widow   -   widow
    redhead -   widow's daughter
    bobby   -   narrator's son
    sonny   -   narrator's father's son 
*/



%%% Facts
male(i).
male(jeff).
male(bobby).
male(sonny).

female(widow).
female(redhead).

parent(jeff, i). % jeff is i's parent
parent(widow, redhead).
parent(i, bobby).
parent(widow, bobby).
parent(jeff, sonny).
parent(redhead, sonny).
parent(i, redhead). % This solves issue with defining step-parents as parents,
                    % since it would have an infinite loop with step/parent(X, Y) = parent(Z, Y), spouse(X, Z). 
                    % Look at "ISSUES" for attempted alternatives.
                    % step_parents(X, Y) has been used as an alternative, even though it leads to ugly code.

spouse(i, widow).
spouse(widow, i).       % Needed to avoid infinite loops.
spouse(jeff, redhead).
spouse(redhead, jeff).  % Needed to avoid infinite loops.


%%% Kinship relationship rules
step_parent(X, Y) :- parent(Z, Y), spouse(X, Z). % Cannot merge with parent(X, Y) because it will create an infinite loop.

son_in_law(X, Y) :- male(X), spouse(X, Z), parent(Y, Z). % Husband of one's child.
son_in_law(X, Y) :- male(X), spouse(X, Z), step_parent(Y, Z). % Step_parent version.
daughter_in_law(X, Y) :-  female(X), spouse(X, Z), parent(Y, Z). % wife of one's child.
daughter_in_law(X, Y) :-  female(X), spouse(X, Z), step_parent(Y, Z). % Step_parent version.

son(X, Y) :- male(X), parent(Y, X).
son(X, Y) :- male(X), step_parent(Y, X). % Step_parent version.
% son(X, Y) :- male(X), parent(Z, X), spouse(Z, Y), \+ parent(Y, X). % STEP-SON: You are the son of your parent's spouse. \+ is used to ignore duplicates covered in first rule.
% son(X, Y) :- male(X), step_parent(Z, X), spouse(Z, Y), \+ parent(Y, X). % Step_parent version.
son(X, Y) :- son_in_law(X, Y). % Song assumes a son-in-law is actually your son since it drops the 'step' label.

daughter(X, Y) :- female(X), parent(Y, X).
daughter(X, Y) :- female(X), step_parent(Y, X). % Step_parent version.
% daughter(X, Y) :- female(X), parent(Z, X), spouse(Z, Y), \+ parent(Y, X). % STEP-DAUGHTER: You are the daughter of your parent's spouse.
% daughter(X, Y) :- female(X), step_parent(Z, X), spouse(Z, Y), \+ parent(Y, X). % Step_parent version.

father(X, Y) :- male(X), parent(X, Y).
father(X, Y) :- male(X), step_parent(X, Y). % Step_parent version.
% father(X, Y) :- male(X), parent(Z, Y), spouse(X, Z), \+ parent(X, Y).  % STEP-FATHER: X is the father of Y if X is Y's mother's husband. \+ is used to ignore duplicates covered in first rule.
% father(X, Y) :- male(X), step_parent(Z, Y), spouse(X, Z), \+ parent(X, Y).  % Step_parent version.

mother(X, Y) :- female(X), parent(X, Y).
mother(X, Y) :- female(X), step_parent(X, Y), \+ parent(X, Y). % Step_parent version.
% mother(X, Y) :- female(X), parent(Z, Y), spouse(X, Z), \+ parent(X, Y). % STEP-MOTHER: X is the mother of Y if X is Y's father's wife. \+ is used to ignore duplicates covered in first rule.
% mother(X, Y) :- female(X), step_parent(Z, Y), spouse(X, Z), \+ parent(X, Y). % Step_parent version.






%%% ISSUES
% parent(X, Y) :- parent(Z, Y), spouse(X, Z).
% step_parent(X, Y) = parent(Z, Y), spouse(X, Z). parent(X, Y) = step_parent(X, Y).