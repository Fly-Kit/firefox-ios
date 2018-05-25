/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import XCTest

class IntegrationTests: BaseTestCase {

    func allowNotifications () {
        addUIInterruptionMonitor(withDescription: "notifications") { (alert) -> Bool in
            alert.buttons["Allow"].tap()
            return true
        }
        sleep(5)
        app.swipeDown()
    }

    private func bookmark() {
        navigator.goto(PageOptionsMenu)
        waitforExistence(app.tables.cells["Bookmark This Page"])
        app.tables.cells["Bookmark This Page"].tap()
        navigator.nowAt(BrowserTab)
    }

    func testFxASyncTabs () {
        navigator.openURL("www.slack.com")
        waitUntilPageLoad()
        navigator.goto(BrowserTabMenu)
        navigator.goto(FxASigninScreen)
        waitforExistence(app.webViews.staticTexts["Sign in"], timeout: 10)
        userState.fxaUsername = ProcessInfo.processInfo.environment["FXA_EMAIL"]!
        userState.fxaPassword = ProcessInfo.processInfo.environment["FXA_PASSWORD"]!
        navigator.performAction(Action.FxATypeEmail)
        navigator.performAction(Action.FxATypePassword)
        navigator.performAction(Action.FxATapOnSignInButton)
        allowNotifications()

        // Wait for initial sync to complete
        navigator.nowAt(BrowserTab)
        navigator.goto(SettingsScreen)
        waitforExistence(app.tables.staticTexts["Sync Now"], timeout: 10)
    }

    func testFxASyncHistory () {
        // Go to a webpage, and add to bookmarks
        navigator.createNewTab()
        waitforExistence(app.textFields["url"])
        app.textFields["url"].tap()
        app.textFields["address"].typeText("www.slack.com")
        app.typeText("\r")
        waitUntilPageLoad()

        // Go to History List from Browser context menu and there should be one entry
        //waitforExistence(app.tables.cells["HistoryPanel.recentlyClosedCell"])
        //XCTAssertTrue(app.tables.cells.staticTexts["Example Domain"].exists)


        // Sign into Firefox Accounts
        navigator.goto(BrowserTabMenu)
        navigator.goto(FxASigninScreen)
        waitforExistence(app.webViews.staticTexts["Sign in"], timeout: 10)
        userState.fxaUsername = ProcessInfo.processInfo.environment["FXA_EMAIL"]!
        userState.fxaPassword = ProcessInfo.processInfo.environment["FXA_PASSWORD"]!
        navigator.performAction(Action.FxATypeEmail)
        navigator.performAction(Action.FxATypePassword)
        navigator.performAction(Action.FxATapOnSignInButton)
        allowNotifications()

        // Wait for initial sync to complete
        navigator.nowAt(BrowserTab)
        navigator.goto(SettingsScreen)
        waitforExistence(app.tables.staticTexts["Sync Now"], timeout: 12)
    }

    func testFxASyncBookmark () {
        // Go to a webpage, and add to bookmarks
        navigator.createNewTab()
        loadWebPage("www.example.com")
        navigator.nowAt(BrowserTab)
        bookmark()

        // Sign into Firefox Accounts
        navigator.goto(FxASigninScreen)
        waitforExistence(app.webViews.staticTexts["Sign in"], timeout: 10)
        userState.fxaUsername = ProcessInfo.processInfo.environment["FXA_EMAIL"]!
        userState.fxaPassword = ProcessInfo.processInfo.environment["FXA_PASSWORD"]!
        navigator.performAction(Action.FxATypeEmail)
        navigator.performAction(Action.FxATypePassword)
        navigator.performAction(Action.FxATapOnSignInButton)
        allowNotifications()

        // Wait for initial sync to complete
        navigator.nowAt(BrowserTab)
        navigator.goto(SettingsScreen)
        waitforExistence(app.tables.staticTexts["Sync Now"], timeout: 10)
    }
}
