
// SKIP @bridgeToSwift
func getJavaSystemProperty(_ name: String) -> String? {
    #if SKIP
    return java.lang.System.getProperty(name)
    #else
    return nil
    #endif
}
