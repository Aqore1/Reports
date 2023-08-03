SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
-- =============================================        
-- Author:  Sasita Maharjan         
-- Create date: 01/31/2019        
-- Description: This Sp is used to select the data for the resume of a person        
-- =============================================               
-- Modified By: Sriti Prajapati        
-- Modification Date: 9/16/2019        
-- Desciption: modification for json ip/op        
-- =============================================  
-- Modified By: Pratigya Thapa        
-- Modification Date: 3/30/2022     
-- Desciption:Bug :32683 , multiple email and phone number showing for multiple address case
-- =============================================  
-- Modified By: Anish Nakarmi     
-- Modification Date: 7/26/2022     
-- Desciption: temp table #workhistory employer column size 50 to 100     
-- =============================================  
--created by: samiksha Poudel on 8/1/2023, custom resume for Nexus, added prefix,suffix, middleinitial, lastinitial, city, state, zipcode 
ALTER PROCEDURE [dbo].[CUONexus_RpPersonResume]
(
    @Json VARCHAR (MAX) OUTPUT ) --= 2000055)        
AS
    BEGIN

        SET NOCOUNT ON;
        IF 1 = 0
            BEGIN
                SET FMTONLY OFF;
            END;

        DECLARE @PersonId VARCHAR (MAX);
        SELECT @PersonId = JSON_VALUE (@Json, '$.PersonId');

        DECLARE @prefixlistitemid INT = dbo.SfListItemIdGet ('Custom', 'Prefix');
        DECLARE @Suffixlistitemid INT = dbo.SfListItemIdGet ('Custom', 'Suffix');

        CREATE TABLE #DistinctPerson
        ( PersonId INT );
        INSERT #DistinctPerson ( PersonId )
               SELECT DISTINCT CAST(value AS INT)
               FROM   STRING_SPLIT(@PersonId, ',') AS br;
        CREATE TABLE #Person
        (   PersonId INT ,
            FirstName NVARCHAR (4000) ,
            MiddleInitial NVARCHAR (1) ,
            LastInitial NVARCHAR (1) ,
            Prefix NVARCHAR (100) ,
            Suffix NVARCHAR (100) ,
            Name NVARCHAR (4000) ,
            Address NVARCHAR (250) ,
            City NVARCHAR (100) ,
            State NVARCHAR (10) ,
           -- Zipcode NVARCHAR (25) ,
            Phone NVARCHAR (500) ,
            Email NVARCHAR (500));
        INSERT INTO #Person ( PersonId ,
                              FirstName ,
                              MiddleInitial ,
                              LastInitial ,
                              City ,
                              State ,
                             -- Zipcode ,
                              -- Name ,
                              --Address ,
                              Phone ,
                              Email )
                    SELECT p.PersonId ,
                           p.FirstName ,
                           LEFT(p.MiddleName, 1) ,
                           LEFT(p.LastName, 1) ,
                           a.City ,
                           s.StateCode ,
                          -- a.ZipCode ,
                           -- p.Name ,
                           --  dbo.SfFullAddressGet (a.AddressId) AS address ,
                           NULLIF(cip.Value, '') AS Phone ,
                           NULLIF(cie.Value, '') AS Email
                    FROM   #DistinctPerson AS dp
                           INNER JOIN dbo.Person AS p ON p.PersonId = dp.PersonId
                           INNER JOIN dbo.PersonCurrent AS pc ON pc.PersonId = p.PersonId
                           LEFT JOIN dbo.ContactInformation AS cip ON pc.PhoneContactInformationId = cip.ContactInformationId
                           LEFT JOIN dbo.ContactInformation AS cie ON pc.EmailContactInformationId = cie.ContactInformationId
                           INNER JOIN dbo.Address AS a ON a.AddressId = pc.AddressId --Bug :32683 , multiple email and phone number showing for multiple address case
                           INNER JOIN dbo.State AS s ON s.StateId = a.StateId;

        -- SELECT * 
        UPDATE p
        SET    p.Prefix = c.Value
        FROM   #Person AS p
               INNER JOIN dbo.Custom AS c ON  c.PersonId = p.PersonId
                                          AND c.CustomListItemId = @prefixlistitemid;

        -- SELECT * 
        UPDATE p
        SET    p.Suffix = CONCAT(', ', c.Value)
        FROM   #Person AS p
               INNER JOIN dbo.Custom AS c ON  c.PersonId = p.PersonId
                                          AND c.CustomListItemId = @Suffixlistitemid;

        --SELECT * 
        UPDATE p
        SET    p.Name = CONCAT (p.Prefix, ' ', p.FirstName, ' ', p.MiddleInitial, ' ', p.LastInitial, p.Suffix) ,
               p.Address = CONCAT (p.City, ', ', p.State)
        FROM   #Person AS p;


        -- SELECT * FROM #DistinctPerson AS dp        
        --SELECT *        
        --FROM   #Person AS p;        
        CREATE TABLE #Education
        (   PersonId INT ,
            Institution NVARCHAR (100) ,
            EducationCity NVARCHAR (50) ,
            EducationState NVARCHAR (25) ,
            Degree VARCHAR (50) ,
            Specialization NVARCHAR (100) ,
            EducationStartDate INT ,
            EducationEndDate INT );


        INSERT INTO #Education ( PersonId ,
                                 Institution ,
                                 EducationCity ,
                                 EducationState ,
                                 Degree ,
                                 Specialization ,
                                 EducationStartDate ,
                                 EducationEndDate )
                    SELECT ped.PersonId ,
                           ped.Institution ,
                           ped.City AS EducationCity ,
                           s3.State AS EducationState ,
                           li.ListItem AS Degree ,
                           ped.Specialization ,
                           YEAR (ped.StartDate) AS EdStartDate ,
                           YEAR (ped.EndDate) AS EdEndDate
                    FROM   #DistinctPerson AS dp
                           INNER JOIN dbo.PersonEducation AS ped ON ped.PersonId = dp.PersonId
                           INNER JOIN dbo.ListItem AS li ON li.ListItemId = ped.DegreeListItemId
                           LEFT JOIN dbo.State AS s3 ON ped.StateId = s3.StateId;


        CREATE TABLE #WorkHistory
        (   PersonId INT ,
            Employer NVARCHAR (100) ,
            Title NVARCHAR (50) ,
            JobDescription VARCHAR (1000) ,
            WorkStartDate SMALLDATETIME ,
            WorkEndDate SMALLDATETIME ,
            WorkCity NVARCHAR (25) ,
            WorkState NVARCHAR (25) ,
            ReferenceName NVARCHAR (500) ,
            Relationshipwithref VARCHAR (50));
        INSERT INTO #WorkHistory ( PersonId ,
                                   Employer ,
                                   Title ,
                                   JobDescription ,
                                   WorkStartDate ,
                                   WorkEndDate ,
                                   WorkCity ,
                                   WorkState ,
                                   ReferenceName ,
                                   Relationshipwithref )
                    SELECT pe.PersonId ,
                           pe.Employer ,
                           pe.Title ,
                           pe.JobDescription ,
                           pe.StartDate AS WorkStartDate ,
                           pe.EndDate AS WorkEndDate ,
                           a2.City AS WorkCity ,
                           s4.State AS WorkState ,
                           CONCAT (pe.ReferenceFirstName, '', pe.ReferenceLastName) AS ReferenceName ,
                           pem.ListItem AS RelationshiptoReference
                    FROM   #DistinctPerson AS dp
                           INNER JOIN dbo.PersonEmployment AS pe ON pe.PersonId = dp.PersonId
                           LEFT JOIN dbo.ListItem AS pem ON pem.ListItemId = pe.ReferenceListItemId
                           LEFT JOIN dbo.Address AS a2 ON pe.AddressId = a2.AddressId
                           LEFT JOIN dbo.State AS s4 ON s4.StateId = a2.StateId;
        --SELECT * FROM #WorkHistory AS wh        


        CREATE TABLE #Interview
        (   PersonId INT ,
            InterviewQuestion VARCHAR (250) ,
            InterviewAnswer NVARCHAR (4000));

        INSERT INTO #Interview ( PersonId ,
                                 InterviewQuestion ,
                                 InterviewAnswer )
                    SELECT PI.PersonId ,
                           pil.Description AS InterviewQuestion ,
                           PI.Answer AS InterviewAnswer
                    FROM   #DistinctPerson AS dp
                           INNER JOIN dbo.PersonInterview AS PI ON PI.PersonId = dp.PersonId
                           INNER JOIN dbo.ListItem AS pil ON pil.ListItemId = PI.InterviewQuestionListItemId;

        CREATE TABLE #Skill
        (   PersonId INT ,
            Skill NVARCHAR (100) ,
            SkillCategory NVARCHAR (50));

        INSERT INTO #Skill ( PersonId ,
                             Skill ,
                             SkillCategory )
                    SELECT ps.PersonId ,
                           s2.Skill ,
                           li.ListItem
                    FROM   #DistinctPerson AS dp
                           INNER JOIN dbo.PersonSkill AS ps ON ps.PersonId = dp.PersonId
                           INNER JOIN dbo.Skill AS s2 ON s2.SkillId = ps.SkillId
                           INNER JOIN dbo.ListItem AS li ON li.ListItemId = s2.SkillCategoryListItemId;


        SELECT @Json = ISNULL (( SELECT   dp.PersonId AS PersonId ,
        ( SELECT *
          FROM   #Person AS p2
          WHERE  p2.PersonId = dp.PersonId
        FOR JSON PATH, INCLUDE_NULL_VALUES ) AS Person ,
        ( SELECT *
          FROM   #Education AS e
          WHERE  e.PersonId = dp.PersonId
        FOR JSON PATH, INCLUDE_NULL_VALUES ) AS Education ,
        ( SELECT *
          FROM   #WorkHistory AS wh
          WHERE  wh.PersonId = dp.PersonId
        FOR JSON PATH, INCLUDE_NULL_VALUES ) AS WorkHistory ,
        ( SELECT *
          FROM   #Interview AS i
          WHERE  i.PersonId = dp.PersonId
        FOR JSON PATH, INCLUDE_NULL_VALUES ) AS Interview ,
        ( SELECT *
          FROM   #Skill AS s
          WHERE  s.PersonId = dp.PersonId
        FOR JSON PATH, INCLUDE_NULL_VALUES ) AS Skill
                                 FROM     #DistinctPerson AS dp
                                          INNER JOIN dbo.Person AS p3 ON p3.PersonId = dp.PersonId
                                 ORDER BY p3.Name
                               FOR JSON PATH, INCLUDE_NULL_VALUES ) ,
                               '[]');
        DROP TABLE #Education ,
                   #Interview ,
                   #Person ,
                   #Skill ,
                   #WorkHistory;


    END;


GO

