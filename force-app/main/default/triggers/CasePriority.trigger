// This trigger sets the Priority field of any new Case to "High" if the associated Account 
// has an AnnualRevenue value greater than 500.
trigger CasePriority on Case (before insert) {

    // Creating a named variable for clarity
    List<Case> newCases = Trigger.new;

    List<Id> accountIds = new List<Id>();

    for(Case theCase : newCases) {

        if(!accountIds.contains(theCase.Id)) {

            accountIds.add(theCase.AccountId);
        }
    }

    List<Account> accounts = [SELECT Id, AnnualRevenue FROM Account WHERE Id IN :accountIds];

    Map<Id, Account> accountMap = new Map<Id, Account>(accounts);

    for(Case theCase : newCases) {

        Account caseAccount = accountMap.get(theCase.AccountId);

        if(caseAccount.AnnualRevenue > 500) {

            theCase.Priority = 'High';
        }
    }
}