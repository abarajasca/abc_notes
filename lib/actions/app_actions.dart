import '../forms/main_form.dart';

enum AppActions {
    save,
    add,
    delete,
    settings,
    export,
    import,
    select,
    search
}

abstract class FormActions {
    void onAction(AppActions action){

    }

    void registerParent(MainFormState mainForm){

    }
}


