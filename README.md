
### 


```SQL
CREATE VIEW [dbo].[contrôle_PurchaseOrder_Entete] AS
```
#
Cette instruction crée une vue nommée contrôle_PurchaseOrder_Entete dans le schéma dbo. Une vue est une requête enregistrée qui peut être utilisée comme une table virtuelle.
### 


```SQL
SELECT
```
#
Cette instruction permet de sélectionner les colonnes à afficher dans la vue.
### 


```SQL
EBELN, – Numéro de commande d’achat
```
#
Cette colonne contient le numéro de commande d’achat.
### 


```SQL
CASE WHEN EBELN IS NULL OR EBELN = ‘’ THEN ‘NOK, Obligatoire’ WHEN EBELN NOT IN ( SELECT EBELN FROM PurchaseOrder_Postes) THEN ‘NOK, commande n’a pas de postes’ ELSE ‘OK’ END AS contrôle_EBELN,
```
#
Cette colonne contient le résultat d’une expression conditionnelle qui vérifie la validité du numéro de commande d’achat. Si le numéro est vide ou nul, la colonne affiche ‘NOK, Obligatoire’. Si le numéro n’existe pas dans la table PurchaseOrder_Postes, la colonne affiche ‘NOK, commande n’a pas de postes’. Sinon, la colonne affiche ‘OK’. La colonne est renommée contrôle_EBELN.
### 


```SQL
UNSEZ, – Numéro de contrat-cadre
```
#
Cette colonne contient le numéro de contrat-cadre.
### 


```SQL
CASE WHEN UNSEZ IS NULL OR UNSEZ = ‘’ THEN ‘NOK, Obligatoire’ WHEN LEN(UNSEZ) &gt; 12 THEN ‘NOK, Longueur’ ELSE ‘OK’ END AS contrôle_UNSEZ,
```
#
Cette colonne contient le résultat d’une expression conditionnelle qui vérifie la validité du numéro de contrat-cadre. Si le numéro est vide ou nul, la colonne affiche ‘NOK, Obligatoire’. Si le numéro a une longueur supérieure à 12 caractères, la colonne affiche ‘NOK, Longueur’. Sinon, la colonne affiche ‘OK’. La colonne est renommée contrôle_UNSEZ.
### 


```SQL
IHREZ, – Numéro de commande client
```
#
Cette colonne contient le numéro de commande client.
### 


```SQL
CASE WHEN LEN(IHREZ) &gt; 12 THEN ‘NOK, Longueur’ ELSE ‘OK’ END AS contrôle_IHREZ,
```
#
Cette colonne contient le résultat d’une expression conditionnelle qui vérifie la validité du numéro de commande client. Si le numéro a une longueur supérieure à 12 caractères, la colonne affiche ‘NOK, Longueur’. Sinon, la colonne affiche ‘OK’. La colonne est renommée contrôle_IHREZ.
### 


```SQL
BSART, – Type de document d’achat
```
#
Cette colonne contient le type de document d’achat.
### 


```SQL
CASE WHEN BSART IS NULL OR BSART = ‘’ THEN ‘NOK, Obligatoire’ WHEN BSART NOT IN ( SELECT BSART FROM dgSAP_SP1_100.dbo.T161 ) THEN ‘NOK, valeur hors liste’ WHEN LEN(BSART) &gt; 4 THEN ‘NOK, Longueur’ ELSE ‘OK’ END AS contrôle_BSART,
```
#
Cette colonne contient le résultat d’une expression conditionnelle qui vérifie la validité du type de document d’achat. Si le type est vide ou nul, la colonne affiche ‘NOK, Obligatoire’. Si le type n’appartient pas à la liste des types autorisés dans la table dgSAP_SP1_100.dbo.T161, la colonne affiche ‘NOK, valeur hors liste’. Si le type a une longueur supérieure à 4 caractères, la colonne affiche ‘NOK, Longueur’. Sinon, la colonne affiche ‘OK’. La colonne est renommée contrôle_BSART.
### 


```SQL
PO.LIFNR, – Numéro de fournisseur
```
#
Cette colonne contient le numéro de fournisseur. PO est un alias donné à la table PurchaseOrder_Entete.
### 


```SQL
CASE WHEN PO.LIFNR IS NULL OR PO.LIFNR = ‘’ THEN ‘NOK, Obligatoire’ WHEN Sup.LIFNR IS NULL THEN ‘NOK, ce fournisseur n’‘a pas été créé’ WHEN Sup2.LIFNR IS NULL THEN ‘NOK, ce fournisseur n’‘a pas été extexionné’ ELSE ‘OK’ END AS contrôle_LIFNR,
```
#
Cette colonne contient le résultat d’une expression conditionnelle qui vérifie la validité du numéro de fournisseur. Si le numéro est vide ou nul, la colonne affiche ‘NOK, Obligatoire’. Si le numéro n’existe pas dans la table Supplier, la colonne affiche ‘NOK, ce fournisseur n’‘a pas été créé’. Si le numéro n’existe pas dans la table SupplierExtension, la colonne affiche ‘NOK, ce fournisseur n’‘a pas été extexionné’. Sinon, la colonne affiche ‘OK’. La colonne est renommée contrôle_LIFNR. Sup et Sup2 sont des alias donnés aux tables Supplier et SupplierExtension.
### 


```SQL
PO.BUKRS, – Code de la société
```
#
Cette colonne contient le code de la société. PO est un alias donné à la table PurchaseOrder_Entete.
### 


```SQL
CASE WHEN PO.BUKRS IS NULL OR PO.BUKRS = ‘’ THEN ‘NOK, Obligatoire’ WHEN PO.BUKRS NOT IN ( SELECT BUKRS FROM dgSAP_SP1_100.dbo.T001 ) THEN ‘NOK, valeur hors liste’ WHEN LEN(PO.BUKRS) &gt; 4 THEN ‘NOK, Longueur’ ELSE ‘OK’ END AS contrôle_BUKRS,
```
#
Cette colonne contient le résultat d’une expression conditionnelle qui vérifie la validité du code de la société. Si le code est vide ou nul, la colonne affiche ‘NOK, Obligatoire’. Si le code n’appartient pas à la liste des codes autorisés dans la table dgSAP_SP1_100.dbo.T001, la colonne affiche ‘NOK, valeur hors liste’. Si le code a une longueur supérieure à 4 caractères, la colonne affiche ‘NOK, Longueur’. Sinon, la colonne affiche ‘OK’. La colonne est renommée contrôle_BUKRS.
### 


```SQL
EKORG, – Organisation d’achat
```
#
Cette colonne contient l’organisation d’achat.
### 


```SQL
CASE WHEN EKORG IS NULL OR EKORG = ‘’ THEN ‘NOK, Obligatoire’ WHEN EKORG NOT IN ( SELECT * FROM _PurchasingOrganization ) THEN ‘NOK, valeur hors liste’ WHEN LEN(EKORG) &gt; 4 THEN ‘NOK, Longueur’ ELSE ‘OK’ END AS contrôle_EKORG,
```
#
Cette colonne contient le résultat d’une expression conditionnelle qui vérifie la validité de l’organisation d’achat. Si l’organisation est vide ou nulle, la colonne affiche ‘NOK, Obligatoire’. Si l’organisation n’appartient pas à la liste des organisations autorisées dans la table _PurchasingOrganization, la colonne affiche ‘NOK, valeur hors liste’. Si l’organisation a une longueur supérieure à 4 caractères, la colonne affiche ‘NOK, Longueur’. Sinon, la colonne affiche ‘OK’. La colonne est renommée contrôle_EKORG.
### 


```SQL
EKGRP, – Groupe d’acheteurs
```
#
Cette colonne contient le groupe d’acheteurs.
### 


```SQL
CASE WHEN EKGRP IS NULL OR EKGRP = ‘’ THEN ‘NOK, Obligatoire’ WHEN EKGRP NOT IN ( SELECT EKGRP FROM dgSAP_SP1_100.dbo.T024 ) THEN ‘NOK, valeur hors liste’ WHEN LEN(EKGRP) &gt; 3 THEN ‘NOK, Longueur’ ELSE ‘OK’ END AS contrôle_EKGRP,
```
#
Cette colonne contient le résultat d’une expression conditionnelle qui vérifie la validité du groupe d’acheteurs. Si le groupe est vide ou nul, la colonne affiche ‘NOK, Obligatoire’. Si le groupe n’appartient pas à la liste des groupes autorisés dans la table dgSAP_SP1_100.dbo.T024, la colonne affiche ‘NOK, valeur hors liste’. Si le groupe a une longueur supérieure à 3 caractères, la colonne affiche ‘NOK, Longueur’. Sinon, la colonne affiche ‘OK’. La colonne est renommée contrôle_EKGRP.
### 


```SQL
ZTERM, – Conditions de paiement
```
#
Cette colonne contient les conditions de paiement.
### 


```SQL
CASE WHEN ZTERM NOT IN ( SELECT * FROM _PaymentTerms ) THEN ‘NOK, valeur hors liste’ WHEN LEN(ZTERM) &gt; 4 THEN ‘NOK, Longueur’ ELSE ‘OK’ END AS contrôle_ZTERM,
```
#
Cette colon
