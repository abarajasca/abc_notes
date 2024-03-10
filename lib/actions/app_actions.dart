enum AppActions {
    save,
    add,
    delete,
    settings,
    export,
    import
}

abstract class FormActions {
    void onAction(AppActions action){

    }
}

