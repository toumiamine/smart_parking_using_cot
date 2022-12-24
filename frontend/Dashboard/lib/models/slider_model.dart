class SliderModel {
  String? image;
  String? text;
  String? altText;
  String? bAltText;
  String? productImage;
  int? kBackgroundColor;

  SliderModel(this.image, this.text, this.altText, this.bAltText,
      this.productImage, this.kBackgroundColor);

  SliderModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    kBackgroundColor = json['kBackgroundColor'];
    text = json['text'];
    altText = json['altText'];
    bAltText = json['bAltText'];
    productImage = json['productImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['kBackgroundColor'] = this.kBackgroundColor;
    data['text'] = this.text;
    data['altText'] = this.altText;
    data['bAltText'] = this.bAltText;
    data['productImage'] = this.productImage;
    return data;
  }
}

List<SliderModel> slides =
    slideData.map((item) => SliderModel.fromJson(item)).toList();

var slideData = [
  {
    "image": "assets/slides/background-1.jpeg",
    "kBackgroundColor": 0xFF2c614f,
    "text": "Welcome to the Smart Parking Admin Dashboard!",
    "altText": "You can access & track your services in real-time.",
    "bAltText": "Are you ready for the next generation Dashboard?",
    "productImage": "assets/images/mockup.png"
  },
  {
    "image": "assets/slides/background-1.jpeg",
    "kBackgroundColor": 0xFF8a1a4c,
    "text": "Bienvenue sur le tableau de bord administratif de Smart Parking !",
    "altText": "Vous pouvez accéder à vos services et les suivre en temps réel.",
    "bAltText": "Êtes-vous prêt pour la nouvelle génération de tableaux de bord ?",
    "productImage": "assets/images/mockup-2.png"
  },
];
