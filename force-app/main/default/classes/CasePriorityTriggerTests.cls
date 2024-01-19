/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CasePriorityTriggerTests {

    @isTest
    static void canSetCasePriorityByAccountAnnualRevenue() {
        
        Account account = new Account( Name = 'Test Account', AnnualRevenue = 10000);
        insert account;

        Case theCase = new Case( Subject = 'Testing our trigger', AccountId = account.Id );
        insert theCase;

        Case caseAfterTrigger = [SELECT Id, Priority FROM Case LIMIT 1];

        Assert.areEqual('High', caseAfterTrigger.Priority);
    }

    @isTest
    static void canSetPriorityForMultipleCasesSameAccount() {
        
        Account account = new Account( Name = 'Test Account', AnnualRevenue = 10000);
        insert account;

        List<Case> cases = new List<Case>();
        cases.Add(new Case( Subject = 'Testing our trigger', AccountId = account.Id ));
        cases.Add(new Case( Subject = 'Testing our trigger again', AccountId = account.Id ));

        insert cases;

        List<Case> resultCases = [SELECT Id, Priority FROM Case];

        for(Case resultCase : resultCases) {
            
            Assert.areEqual('High', resultCase.Priority);
        }
    }

    @isTest
    static void canSetPriorityForManyCases(){

        Account highRevenueAccount = new Account( Name = 'High Revenue Account', AnnualRevenue = 10000);
        insert highRevenueAccount;

        Account lowRevenueAccount = new Account( Name = 'Low Revenue Account', AnnualRevenue = 200);
        insert lowRevenueAccount;

        Integer numberOfCasesToCreate = 500;
        Integer numberOfCasesCreated = 0;

        List<Case> casesToCreate = new List<Case>();

        while(numberOfCasesToCreate > numberOfCasesCreated) {

            Account acct = Math.random() > .5 ? highRevenueAccount : lowRevenueAccount; 

            casesToCreate.add(new Case( Subject = 'canCreateManyCases', AccountId = acct.Id));
            numberOfCasesCreated++;
        }

        insert casesToCreate;

        List<Case> highPriorityCases = [SELECT Id FROM Case WHERE Priority = 'High'];
        List<Case> medPriorityCases = [SELECT Id FROM Case WHERE Priority = 'Medium'];

        Assert.isTrue(highPriorityCases.size() > 0);
        Assert.isTrue(medPriorityCases.size() > 0);
    }

}