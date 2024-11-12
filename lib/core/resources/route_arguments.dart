class MerchandiseItemPageArguments {
  String itemId;
  MerchandiseItemPageArguments({required this.itemId});
}

class SignInPageArguments {
  (int, Object)? itemToAdd;
  SignInPageArguments({this.itemToAdd});
}

class PetProfilePageArguments {
  String petId;
  PetProfilePageArguments({required this.petId});
}
