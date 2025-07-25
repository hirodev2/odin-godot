package example

import "godot:godot"
import "godot:gdext"

// see gdext.InitializationFunction
@(export)
example_library_init :: proc "c" (
    get_proc_address: gdext.ExtensionInterfaceGetProcAddress,
    library: gdext.ExtensionClassLibraryPtr,
    initialization: ^gdext.Initialization,
) -> bool {
    // gdext procs MUST be initialized before using the binding!
    gdext.init(library, get_proc_address)

    // MUST be called before using any core classes, singletons, or utility functions
    godot.init()

    initialization.initialize = initialize_example_module
    initialization.deinitialize = uninitialize_example_module
    initialization.user_data = nil
    initialization.minimum_initialization_level = .Scene

    return true
}

initialize_example_module :: proc "c" (user_data: rawptr, level: gdext.InitializationLevel) {
    context = gdext.godot_context()

    if level != .Scene {
        return
    }

    example_class_register()
}

uninitialize_example_module :: proc "c" (user_data: rawptr, level: gdext.InitializationLevel) {
    context = gdext.godot_context()

    if level != .Scene {
        return
    }
}