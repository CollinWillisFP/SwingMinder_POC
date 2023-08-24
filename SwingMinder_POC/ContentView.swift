//
//  ContentView.swift
//  SwingMinder_POC
//
//  Created by Collin Willis on 8/23/23.
//

import SwiftUI
import AppIntents

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
    
}


let swingTips: [SwingTip] = [
    SwingTip(id: UUID(), situation: "Tee Shot", tip: "Focus on a smooth takeaway and a controlled follow-through."),
    SwingTip(id: UUID(), situation: "Approach Shot", tip: "Choose the right club for the distance and aim for the center of the green."),
    SwingTip(id: UUID(), situation: "Bunker Shot", tip: "Open the clubface, dig your feet in the sand, and aim to hit the sand just behind the ball."),
    SwingTip(id: UUID(), situation: "Putting", tip: "Keep your head steady and practice your rhythm."),
    SwingTip(id: UUID(), situation: "Fairway Shot", tip: "Strike down on the ball and take a divot after impact."),
    SwingTip(id: UUID(), situation: "Lob Shot", tip: "Use a high-lofted wedge and focus on a soft landing."),
    SwingTip(id: UUID(), situation: "Chipping", tip: "Keep your wrists firm and use a pendulum-like motion."),
    SwingTip(id: UUID(), situation: "Punch Shot", tip: "Use a lower lofted club, grip down, and make a compact swing."),
    SwingTip(id: UUID(), situation: "Fade Shot", tip: "Aim slightly left, open the clubface, and create left-to-right spin."),
    SwingTip(id: UUID(), situation: "Draw Shot", tip: "Aim slightly right, close the clubface, and create right-to-left spin."),
    SwingTip(id: UUID(), situation: "Windy Conditions", tip: "Play the ball back in your stance and keep your shots low."),
    SwingTip(id: UUID(), situation: "Uphill Lie", tip: "Aim slightly left, choke down on the club, and swing along the slope."),
    SwingTip(id: UUID(), situation: "Downhill Lie", tip: "Aim slightly right, grip down on the club, and swing along the slope."),
    SwingTip(id: UUID(), situation: "Sidehill Lie", tip: "Adjust your stance to match the slope and swing along the slope."),
    SwingTip(id: UUID(), situation: "Divot Analysis", tip: "Examine your divots for feedback on your swing path."),
    SwingTip(id: UUID(), situation: "Grip Pressure", tip: "Hold the club with a light but controlled grip."),
    SwingTip(id: UUID(), situation: "Alignment", tip: "Check your alignment to ensure you're aiming at your target."),
    SwingTip(id: UUID(), situation: "Pre-shot Routine", tip: "Develop a consistent routine to set up for each shot."),
    SwingTip(id: UUID(), situation: "Swing Tempo", tip: "Focus on a smooth and balanced tempo throughout your swing."),
    SwingTip(id: UUID(), situation: "Grip Alignment", tip: "Ensure the V's formed by your thumbs and index fingers point towards your right shoulder."),
    SwingTip(id: UUID(), situation: "Eyes on the Ball", tip: "Keep your eyes on the ball through impact."),
    SwingTip(id: UUID(), situation: "Weight Transfer", tip: "Shift your weight from back foot to front foot during the downswing."),
    SwingTip(id: UUID(), situation: "Swing Plane", tip: "Maintain a consistent swing plane for better ball striking."),
    SwingTip(id: UUID(), situation: "Club Selection", tip: "Choose the right club for the distance and conditions."),
    SwingTip(id: UUID(), situation: "Posture", tip: "Bend from your hips, not your waist, to maintain a balanced posture."),
    SwingTip(id: UUID(), situation: "Visualize Shots", tip: "Imagine your shot's trajectory and landing spot before you swing."),
    SwingTip(id: UUID(), situation: "Grip Types", tip: "Experiment with different grip styles to find what suits you."),
    SwingTip(id: UUID(), situation: "Practice Routine", tip: "Develop a structured practice routine that covers all aspects of your game."),
    SwingTip(id: UUID(), situation: "Mental Focus", tip: "Stay focused and positive, even after a bad shot."),
    SwingTip(id: UUID(), situation: "Stance Width", tip: "Adjust your stance width based on the club you're using."),
    SwingTip(id: UUID(), situation: "Stay Relaxed", tip: "Maintain relaxed muscles to promote a fluid swing."),
    SwingTip(id: UUID(), situation: "Clubface Control", tip: "Pay attention to the clubface angle at impact."),
    SwingTip(id: UUID(), situation: "Swing Follow-through", tip: "Complete your swing with a balanced and full follow-through.")
]

struct SwingTipAppIntent: AppIntent {
    static let title: LocalizedStringResource = "Get Swing Tip"

      @Parameter(title: "situation")
      var situation: SwingTip?

      @MainActor
      func perform() async throws -> some ProvidesDialog {
        let tipToShow: SwingTip
        if let situation = situation {
            tipToShow = situation
        } else {
            tipToShow = try await $situation.requestDisambiguation(
            among: swingTips,
            dialog: "What tip would you like to see?"
          )
        }
          return .result(dialog: "\(tipToShow.tip)")
      }
}


struct AppShortcuts: AppShortcutsProvider {
  @AppShortcutsBuilder
  static var appShortcuts: [AppShortcut] {
      AppShortcut(
        intent: SwingTipAppIntent(),
        phrases: ["Get swing tip from \(.applicationName)",
                  "Open \(\.$situation) from \(.applicationName) "]
      )
  }
}

struct SwingTip: AppEntity, Hashable {
    var id: UUID
    var situation: String
    var tip: String

  static var typeDisplayRepresentation: TypeDisplayRepresentation = "SwingTip"
  var displayRepresentation: DisplayRepresentation {
    .init(stringLiteral: situation)
  }

  static var defaultQuery = SwingTipQuery()
}


struct SwingTipQuery: EntityQuery {
  func entities(for identifiers: [SwingTip.ID]) async throws -> [SwingTip] {
    swingTips.filter { identifiers.contains($0.id) }
  }

  func suggestedEntities() async throws -> [SwingTip] {
    swingTips
  }
}
