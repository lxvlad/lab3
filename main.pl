% =====================================================================
% ЛАБОРАТОРНА РОБОТА № 3
% Предметна область: База даних студентів університету
% =====================================================================

% 1. БАЗА ДАНИХ (20 записів)
% Формат: student(ID, personal(name(F, L), address(City, Street)), academic(Faculty, Year, GPA), [Subjects], Funding).
% Варіативне поле Funding: state_funded | contract(Price) | exchange(Country).

student(1,  personal(name('Oleh', 'Koval'), address('Kyiv', 'Politekhnichna')), academic('CS', 2, 95.5), ['Math', 'Prolog', 'C++'], state_funded).
student(2,  personal(name('Anna', 'Boyko'), address('Lviv', 'Franko')), academic('Design', 3, 88.0), ['Art', 'Photoshop'], contract(25000)).
student(3,  personal(name('Ihor', 'Shevchenko'), address('Dnipro', 'Gagarin')), academic('CS', 4, 91.2), ['Networks', 'Security'], state_funded).
student(4,  personal(name('Maria', 'Melnyk'), address('Odessa', 'Deribasivska')), academic('Law', 1, 75.0), ['History', 'Logic'], contract(30000)).
student(5,  personal(name('Petro', 'Kravchenko'), address('Lviv', 'Zelena')), academic('Math', 2, 82.3), ['Algebra', 'Geometry'], state_funded).
student(6,  personal(name('Olena', 'Moroz'), address('Kyiv', 'Khreshchatyk')), academic('CS', 3, 98.1), ['Prolog', 'AI', 'Databases'], exchange('Germany')).
student(7,  personal(name('Serhiy', 'Pavlenko'), address('Kharkiv', 'Naukova')), academic('Physics', 1, 65.4), ['Mechanics'], contract(15000)).
student(8,  personal(name('Yuliia', 'Tkach'), address('Kyiv', 'Obolon')), academic('Economics', 4, 89.9), ['Macroeconomics', 'Finance'], state_funded).
student(9,  personal(name('Andriy', 'Kozak'), address('Lviv', 'Stryiska')), academic('CS', 2, 72.0), ['C++', 'Math'], contract(22000)).
student(10, personal(name('Tetiana', 'Rudenko'), address('Odessa', 'Shevchenka')), academic('Law', 3, 94.0), ['Civil Law', 'Ethics'], state_funded).
student(11, personal(name('Dmytro', 'Lysenko'), address('Kyiv', 'Podil')), academic('History', 2, 81.5), ['Archeology'], contract(18000)).
student(12, personal(name('Kateryna', 'Zub'), address('Dnipro', 'Yavornytskoho')), academic('CS', 1, 99.0), ['Prolog', 'Math', 'Physics'], state_funded).
student(13, personal(name('Maksym', 'Sydorenko'), address('Lviv', 'Kopernyka')), academic('Design', 4, 77.8), ['3D Modeling'], contract(25000)).
student(14, personal(name('Alina', 'Bondar'), address('Kyiv', 'Troieshchyna')), academic('Economics', 2, 85.5), ['Marketing', 'Math'], exchange('Poland')).
student(15, personal(name('Roman', 'Savchenko'), address('Kharkiv', 'Pushkinska')), academic('Math', 3, 90.1), ['Topology', 'Statistics'], state_funded).
student(16, personal(name('Iryna', 'Shvets'), address('Lviv', 'Chuprynky')), academic('Physics', 2, 60.5), ['Thermodynamics'], contract(15000)).
student(17, personal(name('Vasyl', 'Hryhorenko'), address('Odessa', 'Fontan')), academic('CS', 4, 88.8), ['AI', 'Data Science'], state_funded).
student(18, personal(name('Oksana', 'Panchenko'), address('Kyiv', 'Pechersk')), academic('Law', 2, 92.4), ['Criminal Law'], state_funded).
student(19, personal(name('Viktor', 'Marchenko'), address('Dnipro', 'Robocha')), academic('Economics', 1, 70.0), ['Microeconomics'], contract(20000)).
student(20, personal(name('Nazar', 'Tymkiv'), address('Lviv', 'Bandery')), academic('CS', 1, 0.0), [], state_funded). % Термінальний елемент (академвідпустка, немає предметів)

% =====================================================================
% 2. УТИЛІТИ ТА СЕЛЕКТОРИ
% =====================================================================

get_name(student(_, personal(name(F, L), _), _, _, _), F, L).
get_city(student(_, personal(_, address(City, _)), _, _, _), City).
get_faculty(student(_, _, academic(Faculty, _, _), _, _), Faculty).
get_gpa(student(_, _, academic(_, _, GPA), _, _), GPA).
get_subjects(student(_, _, _, Subjects, _), Subjects).
get_funding(student(_, _, _, _, Funding), Funding).

% =====================================================================
% 3. ОБРОБКА ВСІХ ЗАПИСІВ БД
% =====================================================================

% А Використання FINDALL: Знайти всіх студентів, які навчаються на 'CS'
all_cs_students(Names) :-
    findall(First, student(_, personal(name(First, _), _), academic('CS', _, _), _, _), Names).

% Б РЕКУРСИВНИЙ ПЕРЕБІР: Підрахунок середнього балу (GPA) списку студентів
sum_gpa([], 0).
sum_gpa([Student | Tail], TotalGPA) :-
    get_gpa(Student, GPA),
    sum_gpa(Tail, TailGPA),
    TotalGPA is GPA + TailGPA.

average_gpa(Avg) :-
    findall(Student, student(Student, _, _, _, _), IDs),
    get_students_by_ids(IDs, StudentsList),
    sum_gpa(StudentsList, TotalGPA),
    length(StudentsList, Count),
    Count > 0,
    Avg is TotalGPA / Count.

get_students_by_ids([], []).
get_students_by_ids([ID | TailIDs], [Student | TailStudents]) :-
    student(ID, P, A, S, F),
    Student = student(ID, P, A, S, F),
    get_students_by_ids(TailIDs, TailStudents).

% В ЕКСТРЕМАЛЬНЕ ЗНАЧЕННЯ: Знайти студента з найвищим балом
best_student(FirstName, LastName, MaxGPA) :-
    student(_, personal(name(FirstName, LastName), _), academic(_, _, MaxGPA), _, _),
    \+ (student(_, _, academic(_, _, OtherGPA), _, _), OtherGPA > MaxGPA).

% Г ТЕРМІНАЛЬНИЙ ЕЛЕМЕНТ: Студент, у якого порожній список предметів
student_on_leave(FirstName, LastName) :-
    student(_, personal(name(FirstName, LastName), _), _, [], _).