USE Formula1

/*1.Cati soferi au unitatea de putere Mercedes pentru fiecare echipa*/
SELECT COUNT(id_sofer) nr_soferi,S.echipa
FROM Soferi S
INNER JOIN Masina M ON
S.id_masina=M.id_masina
INNER JOIN Unitati_De_Putere U ON
M.unitate_de_putere=U.id_unitate_putere
WHERE U.tip_unitate='Mercedes'
GROUP BY S.echipa

/*2.Cati soferi au participat la fiecare cursa si sunt mai multi de 16*/
SELECT COUNT(id_sofer) as 'participari la curse' ,Cl.nume_circuit
FROM Soferi S
INNER JOIN Participare P ON
P.id_soferi_foreign=S.id_sofer
INNER JOIN Curse C ON
C.id_cursa=P.id_curse_foreign
INNER JOIN Calendar Cl ON
Cl.id_calendar=C.id_calendar
WHERE P.participare='Da'
GROUP BY C.id_cursa, Cl.nume_circuit HAVING COUNT(id_sofer)>16

/*3. Cati soferi au mai mult de 20 de pct in clasament si unitatea de putere Ferrari*/
SELECT COUNT(id_sofer) nr_soferi ,U.tip_unitate, C.nume_constructor
FROM Masina M
INNER JOIN Constructori C ON
C.id_constructor=M.constructor
INNER JOIN Campionat_Constructori Cc ON
Cc.id_camp_constructori=C.id_camp_constructori
INNER JOIN Soferi S ON
S.id_masina=M.id_masina
INNER JOIN Unitati_De_Putere U ON
U.id_unitate_putere=M.unitate_de_putere
WHERE Cc.punctaj>20
GROUP BY Cc.id_camp_constructori, U.tip_unitate, C.nume_constructor HAVING COUNT(id_sofer)%2=0


/*4. Soferii care au penuri Soft la masina*/
SELECT Cs.pozitie_sofer, Cs.puncte_sofer, S.nume_sofer
FROM Campionat_Soferi Cs
INNER JOIN Soferi S ON
S.id_camp_soferi=Cs.id_camp_soferi
INNER JOIN Masina M ON
M.sofer=S.id_sofer
INNER JOIN Pneuri P ON
P.id_masina=M.id_masina
WHERE P.tip_pneuri='Soft'

/*5. Constructorii care au mai mult de 950 de cai putere */
SELECT DISTINCT C.nume_constructor, C.director_echipa, C.sponsor_principal
FROM Constructori C
INNER JOIN Masina M ON
C.id_constructor=M.constructor
INNER JOIN Unitati_De_Putere U ON
M.unitate_de_putere=U.id_unitate_putere
WHERE U.cai_putere>950

/*6. Soferii care au pneuri de compozitie C3 */
SELECT Cs.pozitie_sofer, Cs.puncte_sofer, S.nume_sofer, M.culoare, P.compozitie
FROM Campionat_Soferi Cs
INNER JOIN Soferi S ON
Cs.id_camp_soferi=S.id_camp_soferi
INNER JOIN Masina M ON
S.id_masina=M.id_masina
INNER JOIN Pneuri P ON
P.id_masina=M.id_masina
WHERE P.compozitie='C3'

/*7. Constructorii care au soferi cu varsta impara*/
SELECT C.nume_constructor,C.director_echipa, S.nume_sofer, S.varsta 
FROM Constructori C
INNER JOIN Masina M ON
M.constructor=C.id_constructor
INNER JOIN Soferi S ON
S.id_masina=M.id_masina
WHERE S.varsta%2=1

/*8. Masinile care au penuri medii*/
SELECT DISTINCT P.compozitie,P.tip_pneuri, M.culoare
FROM Pneuri P
INNER JOIN Masina M ON
M.unitate_de_putere=P.id_masina
WHERE P.tip_pneuri='Medium'


/*9. Soferii care nu au participat la cursa din Budapesta*/
SELECT S.nume_sofer,S.echipa,P.participare,Cl.oras
FROM Soferi S
INNER JOIN Participare P ON
P.id_soferi_foreign=S.id_sofer
INNER JOIN Curse C ON
C.id_cursa=P.id_curse_foreign
INNER JOIN Calendar Cl ON
Cl.id_calendar=C.id_calendar
WHERE P.participare='Nu' AND Cl.oras='Budapest'


/*10. Soferii care sunt pe pozitii pare in clasament*/
SELECT S.nume_sofer,S.echipa, S.varsta
FROM Soferi S
INNER JOIN Campionat_Soferi C ON
C.id_camp_soferi=S.id_camp_soferi
WHERE C.pozitie_sofer%2=0