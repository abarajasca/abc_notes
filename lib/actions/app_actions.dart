import '../forms/main_form.dart';

enum AppActions {
    save,
    add,
    delete,
    settings,
    export,
    import,
    select
}

abstract class FormActions {
    void onAction(AppActions action){

    }

    void registerParent(MainFormState mainForm){

    }
}


