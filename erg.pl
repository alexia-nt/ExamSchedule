/*---------------------------------------------------------------------------
������������ ������ ��� ������� ��������������� Project 2023

������ => � ��������� ���� ��������� ������������ ��������� ��� ����
��������.

�������������:
������ ���������, 3871
�������� �������, 3961
�����-������ ���������������, 3933
----------------------------------------------------------------------------*/

% �������� �� ��������, ������ ����� ������� ������������ ���� ������.
% attends/2
?-consult('attends.pl').


% E��������� ���� ���������� A, B, C ��� ������ ��������� ��������� ���
% ��� ����� ���������. ���� backtracking �� ���������� ����������
% ����������� ����������� ��������� (����� ���� �����������).
% schedule/3
schedule(A,B,C):-
        % ���������� ���� ������ ��� �������� ��� �� ��������.
        % findall/3
        findall(Subject, (attends(_, Subject) ), Subjects),
        % ��������� �� �������� ���� ������� ����� ��� ������� �� ���������.
        % sort/2
        sort(Subjects,AllSubjects),
        % ���������� ���� �������������� ���� ��� ������� ���������� ��� ������ Courses.
        % permutation/2
        permutation(AllSubjects, List),
        % ������ �� ������� ��� A,B,C.
        % lenght/2
        length(A,3),
        length(B,3),
        length(C,2),
        % ������� ��� List ��� ���� A,B,C.
        % append/3
        append(A,Tmp,List),
        append(B,C,Tmp).

% ������� ���� ���������� A, B, C ��� ��������� ��������� ��� ��� �����
% ��������� ��� ���������� ���� ��������� E ��� ������ ��� ��������
% ��� �������������������, ������ ������ �������� ��� ��� �������� ���
% ���� ��������.
% schedule_errors/4
schedule_errors([A1,A2,A3], [B1,B2,B3], [C1,C2] ,E):-
       % ���������� ���� ������ ��� �������� ��� �� ��� ��� ��������.
       % findall/3
       findall(Aem,(attends(Aem,_Subject)),Students1),
       % ��������� �� ��� ���� ������� ����� ��� ������� �� ���������.
       % sort/2
       sort(Students1,Students),
       students_errors([A1,A2,A3], [B1,B2,B3], [C1,C2], Students, E).


% ���������� �� �������� ������ ��� errors ����������� ���� ���� ���
% ���� ������� ���� errors �������� ��� ��������� ���.
% students_errors/5
students_errors([A1,A2,A3], [B1,B2,B3], [C1,C2], [Aem|RestStudents], E):-
        %�������� ���������� � ��������� ��� ���� ���������� ��������.
        students_errors([A1,A2,A3], [B1,B2,B3], [C1,C2], RestStudents, RestErrors),
        % ������������� �� errors ��� ���� ������������ �������.
        error_calculator([A1,A2,A3], [B1,B2,B3], [C1,C2], Aem, Error),
        %�������� errors ���� ��� ��������.
        E is Error + RestErrors.

% ���� � ����� ��� �������� ��������� ���������� error 0 ���
% ���������� � ��������.
% students_errors/5
students_errors([_A1,_A2,_A3], [_B1,_B2,_B3], [_C1,_C2], [], E):-
        E is 0.

% ������� ��� ���� ������� �� ����� �������� ��� ��� ��������
% ���� ���� ���� �������. �� ����� ���� �� ��� ������� ���� ������� ���
% error.
% error_calculator/5
error_calculator([A1,A2,A3],[B1,B2,B3],[_C1,_C2],Aem,Errors):-
       ((attends(Aem,A1),attends(Aem,A2),attends(Aem,A3));
       (attends(Aem,B1),attends(Aem,B2),attends(Aem,B3))),
       Errors is 1,
       !.

% ������� ��� ���� ������� �� ����� �������� ��� ��� ��������
% ���� ���� ���� �������. �� ����� ��� ���� ��� �������� ����
% �������� ��� errors.
% error_calculator/5
error_calculator([A1,A2,A3],[B1,B2,B3],[_C1,_C2],Aem,Errors):-
       attends(Aem,A1),attends(Aem,A2),attends(Aem,A3),
       attends(Aem,B1),attends(Aem,B2),attends(Aem,B3),
       Errors is 2,
       !.

% ��� ���� ��� ����� ����������� �� error ����� 0.
error_calculator([_A1,_A2,_A3],[_B1,_B2,_B3],[_C1,_C2],_,Errors):-
         Errors is 0.

% ���������� ���� ���������� A, B, C ��� ��������� ��������� ��� ���
% ����� ���������, ��� ����� � ������� ��������������� �������� ��
% ����� � ���������� ������� (������� 0). �� �������� ����������� ���
% ���� ����������� ��������� �� ��� �������� ���� ������, ���� ��
% ������������� ���� backtracking.
% minimal_schedule_errors/4
minimal_schedule_errors(A,B,C,E):-
        % ���������� ���� ������ ��� �������� �� errors ��� ���� ������
        % ��������� ��� ������ �� �����.
        % findall/3
        findall(Error, (schedule(Anew,Bnew,Cnew), schedule_errors(Anew, Bnew,Cnew, Error)), ErrorList),
        % ������� �� ��������� error ��� ��� ����� �� ��� �� errors.
        % min_list/2
        min_list(ErrorList,E),
        %������� ��� �� ������ ����������� ��������� ��� ������� ��
        % ������ �� �� ������������ ��������� error.
        % schedule/3, schedule_errors/4.
        schedule(A,B,C),
        schedule_errors(A,B,C,E).

% ������� ���� ���������� A, B, C ��� ��������� ��������� ��� ��� �����
% ��������� ��� ���������� ���� ��������� S �� score
% schedule_errors/4
score_schedule([A1,A2,A3], [B1,B2,B3], [C1,C2] , S):-
       % ���������� ���� ������ ��� �������� ��� �� ��� ��� ��������.
       % findall/3
       findall(Aem,(attends(Aem,_Subject)),Students1),
       % ��������� �� ��� ���� ������� ����� ��� ������� �� ���������.
       % sort/2
       sort(Students1,Students),
       % ���������� ���� errors �������� ��� ����� �������.
       % weekly3_score/3
       weekly3_score([A1,A2,A3],Students,Score1),
       % ���������� ���� errors �������� ���� ������� �������.
       % weekly3_errors/3
       weekly3_score([B1,B2,B3],Students,Score2),
       % ���������� ���� errors �������� ���� ������� �������.
       % weekly2_errors/3
       weekly2_score([C1,C2],Students,Score3),
       % ���������� �� �������� errors ��� ��� ������������ ���������.
       S is Score1 + Score2 + Score3.

% ���������� �� score ���� ������������� ���������.
% weekly3_score/3
weekly3_score([A,B,C], [Aem|RestStudents],TotalScore):-
       %�������� ���������� � ��������� ��� ���� ���������� ��������.
       weekly3_score([A,B,C], RestStudents,RestScore),
       % ������������ �� score ��� ���� ������������ �������.
       score_week3_calculator([A,B,C], Aem, Score),
       TotalScore is Score + RestScore.

% ���� � ����� ��� �������� ��������� ���������� score 0 ���
% ���������� � ��������.
% weekly3_errors/3
weekly3_score([_A,_B,_C],[],TotalScore):-
        TotalScore is 0.

% ���������� -7 ���� � �������� ���������� �� ��� �� ��������.
% score_week3_calculator/3
score_week3_calculator([A,B,C],Aem,Score):-
       attends(Aem,A),
       attends(Aem,B),
       attends(Aem,C),
       Score is -7,
       !.

% ���������� 3 ���� � �������� ���������� �� ��� �������� ��� �����
% ������� ��� ���������.
% score_week3_calculator/3
score_week3_calculator([A,B,C],Aem,Score):-
       attends(Aem,A),
       not(attends(Aem,B)),
       attends(Aem,C),
       Score is 3,
       !.

% ���������� 1 ���� � �������� ���������� �� ��� ��������.
% score_week3_calculator/3
score_week3_calculator([A,B,C],Aem,Score):-
       attends(Aem,A),
       attends(Aem,B),
       not(attends(Aem,C)),
       Score is 1,
       !.

% ���������� 1 ���� � �������� ���������� �� ��� ��������.
% score_week3_calculator/3
score_week3_calculator([A,B,C],Aem,Score):-
       not(attends(Aem,A)),
       attends(Aem,B),
       attends(Aem,C),
       Score is 1,
       !.

% ���������� 7 ���� � �������� ���������� �� ��� ������.
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

% ���������� �� score ���� ������������� ���������.
% weekly_score/3
weekly2_score([A,B], [Aem|RestStudents],TotalScore):-
       %�������� ���������� � ��������� ��� ���� ���������� ��������.
       weekly2_score([A,B], RestStudents,RestScore),
       % ������������ �� score ��� ���� ������������ �������.
       score_week2_calculator([A,B], Aem, Score),
       TotalScore is Score + RestScore.

% ���� � ����� ��� �������� ��������� ���������� score 0 ���
% ���������� � ��������.
% weekly_errors/3
weekly2_score([_A,_B],[],TotalScore):-
        TotalScore is 0.

% ���������� 1 ���� � �������� ���������� �� ��� �� ��������..
% score_week2_calculator/3
score_week2_calculator([A,B],Aem,Score):-
       attends(Aem,A),
       attends(Aem,B),
       Score is 1,
       !.

% ���������� 7 ���� � �������� ���������� �� ��� ������.
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

% ������� �� ������� score ������ ����� ��� ������������ ��� �����
% ��� �������� ������ ��������������� ��������.
% maximal_score/2
maximal_score(S,E):-
        minimal_schedule_errors(_A,_B,_C,E),
        findall(Score,(minimal_schedule_errors(Anew,Bnew,Cnew,E),score_schedule(Anew,Bnew,Cnew,Score)), Scores),
        max_list(Scores,S),
        !.

% ���������� ���� ���������� A, B, C ��� ��������� ��������� ��� ���
% ����� ���������, ��� ����� � ������� � ��������������� �������� ��
% ����� � ���������� ������� ��� ������ ����� ��� ������������ ��� �����
% ��� �������� ������ ��������������� �������� �� ���������� ���� ��� ��
% ���� ���� �� ����� �������. �� �������� ����������� ��� ����
% ����������� ��������� �� �� ������� ����, ���� ������������� ����
% backtracking.
% maximum_score_schedule/5

maximum_score_schedule(A,B,C,E,S):-
       maximal_score(S,E),
       minimal_schedule_errors(A,B,C,E),
       score_schedule(A,B,C,S).


