import Testing
@testable import task_tracker

@Suite("Terminal formatting")
struct TerminalFormattingTests {

    @Test("visibleCount ignores ANSI escape sequences")
    func visibleCountIgnoresAnsi() {
        #expect(visibleCount("abc") == 3)
        #expect(visibleCount("\u{001B}[32mabc\u{001B}[0m") == 3)
        #expect(visibleCount("\u{001B}[1m\u{001B}[32m  Hello  \u{001B}[0m") == 9)
        #expect(visibleCount("") == 0)
    }

    @Test("visibleCount counts Unicode graphemes as single characters")
    func visibleCountUnicode() {
        #expect(visibleCount("✓") == 1)
        #expect(visibleCount("█░") == 2)
        #expect(visibleCount("zażółć") == 6)
        #expect(visibleCount("│") == 1)
    }

    @Test("priorityLabel maps priorities correctly")
    func priorityLabelMapping() {
        #expect(priorityLabel(1) == "[H]")
        #expect(priorityLabel(2) == "[M]")
        #expect(priorityLabel(3) == "[L]")
        #expect(priorityLabel(99) == "[M]")
    }
}