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
schedule_errors([A1,A2,A3], [B1,B2,B3], [_C1,_C2] , E):-
       % ���������� ���� ������ ��� �������� ��� �� ��� ��� ��������.
       % findall/3
       findall(Aem,(attends(Aem,_Subject)),Students1),
       % ��������� �� ��� ���� ������� ����� ��� ������� �� ���������.
       % sort/2
       sort(Students1,Students),
       % ���������� ���� errors �������� ��� ����� �������.
       % weekly_errors/3
       weekly_errors([A1,A2,A3], Students,Errors1),
       % ���������� ���� errors �������� ���� ������� �������.
       % weekly_errors/3
       weekly_errors([B1,B2,B3], Students,Errors2),
       % ���������� �� �������� errors ��� ��� ������������ ���������.
       E is Errors1 + Errors2.

% ��������: ��� ������ ��� ����� ������� ����� ���� ���� ��� �����
% �������� ��� ��� ������� ��������� �� ��������� ������� ����� �����
% ���� ������� ����.

% ���������� �� errors ���� �������������� ���������.
% weekly_errors/3
weekly_errors([A,B,C], [Aem|RestStudents],AllErrors):-
       %�������� ���������� � ��������� ��� ���� ���������� ��������.
       weekly_errors([A,B,C], RestStudents,RestErrors),
       % ������������ �� error ��� ���� ������������ �������.
       error_calculator([A,B,C], Aem, Error),
       AllErrors is Error + RestErrors .

% ���� � ����� ��� �������� ��������� ���������� error 0 ���
% ���������� � ��������.
% weekly_errors/3
weekly_errors([_A,_B,_C],[] ,AllErrors):-
        AllErrors is 0.

% ������� ��� ���� ������� �� ����� �������� ��� ��� ��������
% ���� ���� ���� �������. �� ����� ���� ������� ��� error.
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







