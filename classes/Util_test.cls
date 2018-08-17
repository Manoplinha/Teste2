@istest
public with sharing class Util_test {
	
    @isTest static void testUtil() {
    	
        list<String> valist = new list<String>();
        valist.add('Paula');
        valist.add('João');
        valist.add('Pedro');
            
        Test.startTest();  
        	Integer numero = Util.getClosestString('a', valist);
        Test.stopTest();
        
    }
}