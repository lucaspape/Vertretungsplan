//Umlauts bullshit
String convertChars(String text) {
  return (text
      .replaceAll('Ã¤', 'ä')
      .replaceAll('Ã¶', 'ö')
      .replaceAll('Ã¼', 'ü'));
}
