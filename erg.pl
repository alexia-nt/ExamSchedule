/*---------------------------------------------------------------------------
Υπολογιστική Λογική και Λογικός Προγραμματισμός Project 2023

Στόχος => Η κατασκευή ενός βέλτιστου προγράμματος εξετάσεων για τους
φοιτητές.

Συμμετέχοντες:
Αλεξία Νταντουρή, 3871
Καλλιόπη Πλιόγκα, 3961
Μαρία-Νεφέλη Παρασκευοπούλου, 3933
----------------------------------------------------------------------------*/

% Περιέχει τα δεδομένα, δηλαδή ποιος μαθητής παρακολουθεί ποιό μάθημα.
% attends/2
?-consult('attends.pl').


% Eπιστρέφει στις μεταβλητές A, B, C ένα τυχαίο πρόγραμμα εξετάσεων για
% τις τρεις εβδομάδες. Μέσω backtracking το κατηγόρημα επιστρέφει
% εναλλακτικά προγράμματα εξετάσεων (όλους τους συνδυασμούς).
% schedule/3
schedule(A,B,C):-
        % Δημιουργία μιας λίστας που περιέχει όλα τα μαθήματα.
        % findall/3
        findall(Subject, (attends(_, Subject) ), Subjects),
        % Ταξινομεί τα μαθήματα κατά αύξουσα σειρά και αφαιρεί τα διπλότυπα.
        % sort/2
        sort(Subjects,AllSubjects),
        % Επιστρέφει μέσω οπισθοδρόμησης όλες τις δυνατές μεταθέσεις της λίστας Courses.
        % permutation/2
        permutation(AllSubjects, List),
        % Ορίζει το μέγεθος των A,B,C.
        % lenght/2
        length(A,3),
        length(B,3),
        length(C,2),
        % Χωρίζει την List στα μέρη A,B,C.
        % append/3
        append(A,Tmp,List),
        append(B,C,Tmp).

% Δίνουμε στις μεταβλητές A, B, C ένα πρόγραμμα εξετάσεων για τις τρεις
% εβδομάδες και Επιστρέφει στην μεταβλητή E τον αριθμό των φοιτητών
% που είναι«δυσαρεστημένοι», δηλαδή δίνουν παραπάνω από δύο μαθήματα την
% ίδια εβδομάδα.
% schedule_errors/4
schedule_errors([A1,A2,A3], [B1,B2,B3], [C1,C2] ,E):-
       % Δημιουργία μιας λίστας που περιέχει όλα τα ΑΕΜ των φοιτητών.
       % findall/3
       findall(Aem,(attends(Aem,_Subject)),Students1),
       % Ταξινομεί τα ΑΕΜ κατά αύξουσα σειρά και αφαιρεί τα διπλότυπα.
       % sort/2
       sort(Students1,Students),
       students_errors([A1,A2,A3], [B1,B2,B3], [C1,C2], Students, E).


% Υπολογίζει το συνολικό πλήθος των errors εξετάζοντας κάθε φορά για
% έναν φοιτητή πόσα errors υπαρχουν στο πρόγραμμά του.
% students_errors/5
students_errors([A1,A2,A3], [B1,B2,B3], [C1,C2], [Aem|RestStudents], E):-
        %Καλείται αναδρομικά η συνάρτηση για τους υπόλοιπους φοιτητές.
        students_errors([A1,A2,A3], [B1,B2,B3], [C1,C2], RestStudents, RestErrors),
        % Υπολογίζονται τα errors για έναν συγκεκριμένο φοιτητή.
        error_calculator([A1,A2,A3], [B1,B2,B3], [C1,C2], Aem, Error),
        %Συνολικά errors όλων των φοιτητών.
        E is Error + RestErrors.

% Οταν η λίστα των φοιτητών τελειώσει επιστρέφει error 0 και
% τερματιζει η αναδρομή.
% students_errors/5
students_errors([_A1,_A2,_A3], [_B1,_B2,_B3], [_C1,_C2], [], E):-
        E is 0.

% Έλεγχος για κάθε φοιτητή αν δίνει παραπάνω από δύο μαθήματα
% μέσα στην ίδια βδομάδα. Αν δίνει μόνο σε μια βδομάδα τότε υπάρχει ένα
% error.
% error_calculator/5
error_calculator([A1,A2,A3],[B1,B2,B3],[_C1,_C2],Aem,Errors):-
       ((attends(Aem,A1),attends(Aem,A2),attends(Aem,A3));
       (attends(Aem,B1),attends(Aem,B2),attends(Aem,B3))),
       Errors is 1,
       !.

% Έλεγχος για κάθε φοιτητή αν δίνει παραπάνω από δύο μαθήματα
% μέσα στην ίδια βδομάδα. Αν δίνει και στις δύο βδομάδες τότε
% υπάρχουν δύο errors.
% error_calculator/5
error_calculator([A1,A2,A3],[B1,B2,B3],[_C1,_C2],Aem,Errors):-
       attends(Aem,A1),attends(Aem,A2),attends(Aem,A3),
       attends(Aem,B1),attends(Aem,B2),attends(Aem,B3),
       Errors is 2,
       !.

% Για όλες τις άλλες περιπτώσεις το error είναι 0.
error_calculator([_A1,_A2,_A3],[_B1,_B2,_B3],[_C1,_C2],_,Errors):-
         Errors is 0.

% Επιστρέφει στις μεταβλητές A, B, C ένα πρόγραμμα εξετάσεων για τις
% τρεις εβδομάδες, στο οποίο ο αριθμός «δυσαρεστημένων» φοιτητών να
% είναι ο μικρότερος δυνατός (ιδανικά 0). Αν υπάρχουν περισσότερα του
% ενός προγράμματα εξετάσεων με τον βέλτιστο αυτό αριθμό, τότε να
% επιστρέφονται μέσω backtracking.
% minimal_schedule_errors/4
minimal_schedule_errors(A,B,C,E):-
        % Δημιουργία μιας λίστας που περιέχει τα errors για κάθε πιθανό
        % πρόγραμμα που μπορεί να γίνει.
        % findall/3
        findall(Error, (schedule(Anew,Bnew,Cnew), schedule_errors(Anew, Bnew,Cnew, Error)), ErrorList),
        % Βρίσκει το μιρκότερο error από την λίστα με όλα τα errors.
        % min_list/2
        min_list(ErrorList,E),
        %Βρίσκει όλα τα πιθανά προγράμματα εξετάσεων που μπορούν να
        % γίνουν με το συγκεκριμένο μικρότερο error.
        % schedule/3, schedule_errors/4.
        schedule(A,B,C),
        schedule_errors(A,B,C,E).

% Δίνουμε στις μεταβλητές A, B, C ένα πρόγραμμα εξετάσεων για τις τρεις
% εβδομάδες και Επιστρέφει στην μεταβλητή S το score
% schedule_errors/4
score_schedule([A1,A2,A3], [B1,B2,B3], [C1,C2] , S):-
       % Δημιουργία μιας λίστας που περιέχει όλα τα ΑΕΜ των φοιτητών.
       % findall/3
       findall(Aem,(attends(Aem,_Subject)),Students1),
       % Ταξινομεί τα ΑΕΜ κατά αύξουσα σειρά και αφαιρεί τα διπλότυπα.
       % sort/2
       sort(Students1,Students),
       % Υπολογίζει πόσα errors υπάρχουν στη πρώτη βδομάδα.
       % weekly3_score/3
       weekly3_score([A1,A2,A3],Students,Score1),
       % Υπολογίζει πόσα errors υπάρχουν στην δεύτερη βδομάδα.
       % weekly3_errors/3
       weekly3_score([B1,B2,B3],Students,Score2),
       % Υπολογίζει πόσα errors υπάρχουν στην δεύτερη βδομάδα.
       % weekly2_errors/3
       weekly2_score([C1,C2],Students,Score3),
       % Υπολογίζει τα συνολικά errors για τον συγκεκριμένο πρόγραμμα.
       S is Score1 + Score2 + Score3.

% Υπολογίζει το score μιας συγκεκριμένης εβδομάδας.
% weekly3_score/3
weekly3_score([A,B,C], [Aem|RestStudents],TotalScore):-
       %Καλείται αναδρομικά η συνάρτηση για τους υπόλοιπους φοιτητές.
       weekly3_score([A,B,C], RestStudents,RestScore),
       % Υπολογίζεται το score για έναν συγκεκριμένο φοιτητή.
       score_week3_calculator([A,B,C], Aem, Score),
       TotalScore is Score + RestScore.

% Οταν η λίστα των φοιτητών τελειώσει επιστρέφει score 0 και
% τερματιζει η αναδρομή.
% weekly3_errors/3
weekly3_score([_A,_B,_C],[],TotalScore):-
        TotalScore is 0.

% Επιστρέφει -7 όταν ο φοιτητής εξετάζεται σε όλα τα μαθήματα.
% score_week3_calculator/3
score_week3_calculator([A,B,C],Aem,Score):-
       attends(Aem,A),
       attends(Aem,B),
       attends(Aem,C),
       Score is -7,
       !.

% Επιστρέφει 3 όταν ο φοιτητής εξετάζεται σε δύο μαθήματα και δίνει
% Δευτέρα και Παρασκευή.
% score_week3_calculator/3
score_week3_calculator([A,B,C],Aem,Score):-
       attends(Aem,A),
       not(attends(Aem,B)),
       attends(Aem,C),
       Score is 3,
       !.

% Επιστρέφει 1 όταν ο φοιτητής εξετάζεται σε δύο μαθήματα.
% score_week3_calculator/3
score_week3_calculator([A,B,C],Aem,Score):-
       attends(Aem,A),
       attends(Aem,B),
       not(attends(Aem,C)),
       Score is 1,
       !.

% Επιστρέφει 1 όταν ο φοιτητής εξετάζεται σε δύο μαθήματα.
% score_week3_calculator/3
score_week3_calculator([A,B,C],Aem,Score):-
       not(attends(Aem,A)),
       attends(Aem,B),
       attends(Aem,C),
       Score is 1,
       !.

% Επιστρέφει 7 όταν ο φοιτητής εξετάζεται σε ένα μάθημα.
% score_week3_calculator/3
score_week3_calculator([A,B,C],Aem,Score):-
       attends(Aem,A),
       not(attends(Aem,B)),
       not(attends(Aem,C)),
       Score is 7,
       !.
score_week3_calculator([A,B,C],Aem,Score):-
       not(attends(Aem,A)),
       attends(Aem,B),
       not(attends(Aem,C)),
       Score is 7,
       !.
score_week3_calculator([A,B,C],Aem,Score):-
       not(attends(Aem,A)),
       not(attends(Aem,B)),
       attends(Aem,C),
       Score is 7,
       !.

score_week3_calculator([_,_,_],_,Score):-
       Score is 0.

% Υπολογίζει το score μιας συγκεκριμένης εβδομάδας.
% weekly_score/3
weekly2_score([A,B], [Aem|RestStudents],TotalScore):-
       %Καλείται αναδρομικά η συνάρτηση για τους υπόλοιπους φοιτητές.
       weekly2_score([A,B], RestStudents,RestScore),
       % Υπολογίζεται το score για έναν συγκεκριμένο φοιτητή.
       score_week2_calculator([A,B], Aem, Score),
       TotalScore is Score + RestScore.

% Οταν η λίστα των φοιτητών τελειώσει επιστρέφει score 0 και
% τερματιζει η αναδρομή.
% weekly_errors/3
weekly2_score([_A,_B],[],TotalScore):-
        TotalScore is 0.

% Επιστρέφει 1 όταν ο φοιτητής εξετάζεται σε όλα τα μαθήματα..
% score_week2_calculator/3
score_week2_calculator([A,B],Aem,Score):-
       attends(Aem,A),
       attends(Aem,B),
       Score is 1,
       !.

% Επιστρέφει 7 όταν ο φοιτητής εξετάζεται σε ένα μάθημα.
% score_week2_calculator/3
score_week2_calculator([A,B],Aem,Score):-
       attends(Aem,A),
       not(attends(Aem,B)),
       Score is 7,
       !.

score_week2_calculator([A,B],Aem,Score):-
       not(attends(Aem,A)),
       attends(Aem,B),
       Score is 7,
       !.

score_week2_calculator([_,_],_,Score):-
       Score is 0.

% Βρίσκει το μέγιστο score μεταξύ αυτών των προγραμμάτων που έχουν
% τον ελάχιστο αριθμό «δυσαρεστημένων» φοιτητών.
% maximal_score/2
maximal_score(S,E):-
        minimal_schedule_errors(_A,_B,_C,E),
        findall(Score,(minimal_schedule_errors(Anew,Bnew,Cnew,E),score_schedule(Anew,Bnew,Cnew,Score)), Scores),
        max_list(Scores,S),
        !.

% Επιστρέφει στις μεταβλητές A, B, C ένα πρόγραμμα εξετάσεων για τις
% τρεις εβδομάδες, στο οποίο ο αριθμός Ε «δυσαρεστημένων» φοιτητών να
% είναι ο μικρότερος δυνατός και μεταξύ αυτών των προγραμμάτων που έχουν
% τον ελάχιστο αριθμό «δυσαρεστημένων» φοιτητών να επιστρέφει αυτά που το
% σκορ τους να είναι μέγιστο. Αν υπάρχουν περισσότερα του ενός
% προγράμματα εξετάσεων με το μέγιστο σκορ, τότε επιστρέφονται μέσω
% backtracking.
% maximum_score_schedule/5

maximum_score_schedule(A,B,C,E,S):-
       maximal_score(S,E),
       minimal_schedule_errors(A,B,C,E),
       score_schedule(A,B,C,S).


