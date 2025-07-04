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

parent(jeff, i). % jeff is i's parent
parent(widow, redhead).
parent(i, bobby).
parent(widow, bobby).
parent(jeff, sonny).
parent(redhead, sonny).

spouse(i, widow).
spouse(widow, i).       % Needed to avoid infinite loops.
spouse(jeff, redhead).
spouse(redhead, jeff).  % Needed to avoid infinite loops.


%%% Kinship relationship rules
step_parent(X, Y) :- parent(Z, Y), spouse(X, Z), \+ parent(X, Y). % \+ parent keeps step and biological parents seperate to avoid duplicated.

% isParentOf() will now be used instead of parent() as a generalized (step+biological) form of parenthood.
isParentOf(X, Y) :- parent(X, Y).
isParentOf(X, Y) :- step_parent(X, Y).

father(X, Y) :- male(X), isParentOf(X, Y).
mother(X, Y) :- female(X), isParentOf(X, Y).

son(X, Y) :- male(X), isParentOf(Y, X).
son(X, Y) :- son_in_law(X, Y). % Song assumes a son-in-law is actually your son since it drops the 'step' label.
son_in_law(X, Y) :- male(X), spouse(X, Z), isParentOf(Y, Z). % Husband of one's child.

daughter(X, Y) :- female(X), isParentOf(Y, X).
daughter_in_law(X, Y) :-  female(X), spouse(X, Z), isParentOf(Y, Z). % wife of one's child.

grand_parent(X, Y) :- isParentOf(X, Z), isParentOf(Z, Y).
grand_father(X, Y) :- male(X), isParentOf(X, Z), isParentOf(Z, Y).
grand_mother(X, Y) :- female(X), isParentOf(X, Z), isParentOf(Z, Y).

grand_child(X, Y) :- grand_parent(Y, X).

sibling(X, Y) :- isParentOf(Z, X), isParentOf(Z, Y).
brother(X, Y) :- male(X), isParentOf(Z, X), isParentOf(Z, Y), X\=Y.
sister(X, Y) :- female(X), isParentOf(Z, X), isParentOf(Z, Y), X\=Y.

uncle(X, Y) :- male(X), isParentOf(Z, Y), sibling(Z, X).
aunty(X, Y) :- female(X), isParentOf(Z, Y), sibling(Z, X).


%%% ISSUES
% parent(X, Y) :- parent(Z, Y), spouse(X, Z).
% step_parent(X, Y) = parent(Z, Y), spouse(X, Z). parent(X, Y) = step_parent(X, Y).
% ^ Cannot merge with parent(X, Y) because it will create an infinite loop. 

% parent(i, redhead). % This solves issue with defining step-parents as parents,
                    % since it would have an infinite loop with step/parent(X, Y) = parent(Z, Y), spouse(X, Z). 
                    % Look at "ISSUES" for attempted alternatives.
                    % step_parents(X, Y) has been used as an alternative, even though it leads to ugly code.