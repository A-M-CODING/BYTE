class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Scan food products on the go",
    image: "assets/images/image1.png",
    desc:
        "Now you can get immediate advice on how a food product will affect your health. Decoding nutritional labels has never been easier!",
  ),
  OnboardingContents(
    title: "Get alternatives curated just for you",
    image: "assets/images/image2.png",
    desc:
        "You no longer have to miss out on your favourite foods just because of your dietary restrictions - we provide a bunch of healthier alternatives!.",
  ),
  OnboardingContents(
    title: "Connect with the community",
    image: "assets/images/image3.png",
    desc:
        "Find people who share your dietary restrictions and get advice on how to live a healthier life. Share your experiences and learn from others!",
  ),
];
