void AimPitch() {
    CTrackMania@ app = cast<CTrackMania>(GetApp());
    auto playground = cast<CSmArenaClient>(app.CurrentPlayground);

    auto script = cast<CSmScriptPlayer>(playground.Arena.Players[0].ScriptAPI);

    float aimYaw = 0.0;
    float aimPitch = 0.0;
    float aimRoll = 0.0;

    if (script !is null) {
        aimYaw = script.AimYaw;
        aimPitch = script.AimPitch;
        aimRoll = script.AimRoll;
//        print("Yaw'" + aimYaw + "' - Pitch'" + aimPitch + "'' - Roll'" + aimRoll + "'");
    }

    vec2 sizePitch = Setting_AimPitch_Size;
    vec2 posPitch = Setting_AimPitch_Pos;
    vec2 screenSize = vec2(Draw::GetWidth(), Draw::GetHeight());
    vec2 origin = posPitch * (screenSize - sizePitch);

    float border_radius = 2.0;
    nvg::BeginPath();

    vec2 center = vec2(origin.x + sizePitch.x / 2.0, origin.y + sizePitch.y / 2.0);
    float radius = sizePitch.x / 2.0;

    // Draw the circle
    nvg::Circle(center, radius);
    nvg::StrokeColor(Setting_General_BorderColor);
    nvg::StrokeWidth(2.0);
    nvg::Stroke();

    // Draw the tick marks
    int numTicks = 7;
    float tickLength = 0.1 * radius;
    float tickStart = -3.14159265359 * 1.5;
    float tickEnd = 3.14159265359 * 0.5;
    float tickIncrement = (tickEnd - tickStart) / (numTicks - 1);
    float tickAngle = tickStart;

    

    for (int i = 0; i < numTicks; i++) {
        vec2 tickStartPos = center + vec2(radius * Math::Cos(tickAngle), radius * Math::Sin(tickAngle));
        vec2 tickEndPos = tickStartPos + tickLength * vec2(Math::Cos(tickAngle), Math::Sin(tickAngle));
        nvg::BeginPath();
        nvg::MoveTo(tickStartPos);
        nvg::LineTo(tickEndPos);
        nvg::StrokeWidth(1.0);
        nvg::StrokeColor(Setting_General_MarkerColor);
        nvg::Stroke();
        tickAngle += tickIncrement;
    }

    // Draw the dial value
    if (script !is null) {
        aimPitch = script.AimPitch;
    }
    float valueAngle = (aimPitch - -3.14) / (3.14 - -3.14) * (tickEnd - tickStart) + tickStart;
    vec2 valuePos = center + 0.6 * radius * vec2(Math::Cos(valueAngle), Math::Sin(valueAngle));
    
    nvg::BeginPath();
    nvg::Circle(valuePos, tickLength * 0.7);
    nvg::FillColor(Setting_General_FillColor);
    nvg::Fill();
    nvg::ClosePath();


    // Draw "Pitch" in the center
    nvg::BeginPath();
    nvg::FontSize(18.0);
    nvg::FillColor(Setting_General_TextColor);
    nvg::TextAlign(nvg::Align::Center | nvg::Align::Middle);
    nvg::Text(center, "Pitch");
    nvg::ClosePath();

}



