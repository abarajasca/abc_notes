import '../forms/main_form.dart';

enum AppActions {
    save,
    add,
    delete,
    settings,
    export,
    import,
    select,
    search,
    sort_title,
    sort_category,
    sort_time,
    select_all,
    unselect_all,
    backup,
    restore
}

abstract class FormActions {
    void onAction(AppActions action){

    }

    void registerParent(MainFormState mainForm){

    }
}


