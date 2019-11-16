class SharedFunctions {
  SharedFunctions(this.parent);

  final dynamic parent;

  void _resetForm() {
    parent.formKey.currentState.reset();
    parent.errorMessage = "";
  }

  void toggleFormMode() {
    _resetForm();
    parent.setState(() {
      parent.isLoginForm = !parent.isLoginForm;
    });
  }

  String validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    final RegExp nameExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!nameExp.hasMatch(value)) return 'Please enter a valid email address.';
    parent.email = value.trim();
    return null;
  }

  String validatePassword(String value) {
    parent.password = value;
    if (value.isEmpty) return 'Password is required.';
    if (!parent.isLoginForm) {
      if (value.length < 6)
        return 'A password longer than 5 characters is required.';
    }
    return null;
  }
}
