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
schedule_errors([A1,A2,A3], [B1,B2,B3], [_C1,_C2] , E):-
       % Δημιουργία μιας λίστας που περιέχει όλα τα ΑΕΜ των φοιτητών.
       % findall/3
       findall(Aem,(attends(Aem,_Subject)),Students1),
       % Ταξινομεί τα ΑΕΜ κατά αύξουσα σειρά και αφαιρεί τα διπλότυπα.
       % sort/2
       sort(Students1,Students),
       % Υπολογίζει πόσα errors υπάρχουν στη πρώτη βδομάδα.
       % weekly_errors/3
       weekly_errors([A1,A2,A3], Students,Errors1),
       % Υπολογίζει πόσα errors υπάρχουν στην δεύτερη βδομάδα.
       % weekly_errors/3
       weekly_errors([B1,B2,B3], Students,Errors2),
       % Υπολογίζει τα συνολικά errors για τον συγκεκριμένο πρόγραμμα.
       E is Errors1 + Errors2.

% Σημείωση: δεν ελέγχω την τρίτη βδομάδα καθώς έχει μόνο δύο μέρες
% εξέτασης και δεν υπάρχει περίπτωση να εξεταστεί καποιος τρεις μέρες
% στην βδομάδα αυτή.

% Υπολογίζει τα errors μιας συγκεκριμένεις εβδομάδας.
% weekly_errors/3
weekly_errors([A,B,C], [Aem|RestStudents],AllErrors):-
       %Καλείται αναδρομικά η συνάρτηση για τους υπόλοιπους φοιτητές.
       weekly_errors([A,B,C], RestStudents,RestErrors),
       % Υπολογίζεται το error για έναν συγκεκριμένο φοιτητή.
       error_calculator([A,B,C], Aem, Error),
       AllErrors is Error + RestErrors .

% Οταν η λίστα των φοιτητών τελειώσει επιστρέφει error 0 και
% τερματιζει η αναδρομή.
% weekly_errors/3
weekly_errors([_A,_B,_C],[] ,AllErrors):-
        AllErrors is 0.

% Έλεγχος για κάθε φοιτητή αν δίνει παραπάνω από δύο μαθήματα
% μέσα στην ίδια βδομάδα. Αν δίνει τότε υπάρχει ένα error.
% error_calculator/3
error_calculator([A,B,C],Aem,Errors):-
       attends(Aem,A),
       attends(Aem,B),
       attends(Aem,C),
       Errors is 1.
error_calculator([A,B,C],Aem,Errors):-
       not(attends(Aem,A)),
       not(attends(Aem,B)),
       not(attends(Aem,C)),
       Errors is 0.
error_calculator([A,B,C],Aem,Errors):-
       attends(Aem,A),
       not(attends(Aem,B)),
       not(attends(Aem,C)),
       Errors is 0.
error_calculator([A,B,C],Aem,Errors):-
       not(attends(Aem,A)),
       attends(Aem,B),
       not(attends(Aem,C)),
       Errors is 0.
error_calculator([A,B,C],Aem,Errors):-
       not(attends(Aem,A)),
       not(attends(Aem,B)),
       attends(Aem,C),
       Errors is 0.
error_calculator([A,B,C],Aem,Errors):-
       not(attends(Aem,A)),
       attends(Aem,B),
       attends(Aem,C),
       Errors is 0.
error_calculator([A,B,C],Aem,Errors):-
       attends(Aem,A),
       not(attends(Aem,B)),
       attends(Aem,C),
       Errors is 0.
error_calculator([A,B,C],Aem,Errors):-
       attends(Aem,A),
       attends(Aem,B),
       not(attends(Aem,C)),
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







