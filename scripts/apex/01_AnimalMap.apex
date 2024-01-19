Map<Integer, String> animalMap = new Map<Integer, String>();

animalMap.put(0, 'Lion');
animalMap.put(1, 'Bear');
animalMap.put(2, 'Monkey');

String animal = animalMap.get(2);

// The value of animal for Key 2 is: Monkey
System.debug('The animal for Key 2 is: ' + animal);