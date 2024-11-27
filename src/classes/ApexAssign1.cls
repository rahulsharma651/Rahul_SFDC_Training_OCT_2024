/**Purpose:Class To Perform Map And List In Static Way For Practice Maps and Lists.

Created by: Rahul Sharma

Created Date : 27-11-24

Rivision Log: V:1.1

**/
public class ApexAssign1 {

    public static void Apex1_a() {
        String Department; 
        Map<String, List<String>> Map_1 = new Map<String, List<String>>();
        Map_1.put('Sales', new List<String>{'Rahul', 'Amit'});
        Map_1.put('Customer_Support', new List<String>{'Sumit', 'Sajal'});      
        System.debug(Map_1);
    }  
    public static void Apex1_b() {
        Set<String> Group1 = new Set<String>{'Rahul', 'Piyush', 'Sumit', 'Priyanshu'};
        Set<String> Group2 = new Set<String>{'Sumit', 'Shubham', 'Rakesh', 'Priyanshu'};
        Set<String> Group_Union = new Set<String>();

        
        Group_Union.addAll(Group1);
        Group_Union.addAll(Group2);
        
        Set<String> Group_Intersection = new Set<String>();      
        Set<String> Group_Difference = new Set<String>();       
        for (String i : Group2) {
            if (Group1.contains(i)) {
                Group_Intersection.add(i);
            }
        }
        for (String i : Group2) {
            if (!Group1.contains(i)) {
                Group_Difference.add(i);
            }
        }
        
        System.debug('Intersection of Group1 and Group2: ' + Group_Intersection);
        System.debug('Difference of Group1 and Group2: ' + Group_Difference);
        System.debug('Union of Group1 and Group2: ' + Group_Union);
    }
    
    public static void Apex1_c() {
        
        List<Integer> numbers = new List<Integer>();      
        for (Integer i = 0; i < 10; i++) {
            Integer randomNum = Math.round(Math.random() * 100);
            numbers.add(randomNum);
        }  
        numbers.sort();
        System.debug('Sorted Numbers: ' + numbers);
    }
}