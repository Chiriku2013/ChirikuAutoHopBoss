loadstring(game:HttpGet(("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua")))()

       local Window = MakeWindow({
         Hub = {
         Title = "Chiriku Roblox Hub",
         Animation = "Chiriku Auto Hop Boss"
         },
        Key = {
        KeySystem = true,
        Title = "Get Key",
        Description = "Script by rip_chiriku",
        KeyLink = "https://pastebin.com/6dTbNVck",
        Keys = {"ChirikuNigga"},
        Notifi = {
        Notifications = true,
        CorrectKey = "Đang chạy script...",
       Incorrectkey = "Key sai",
       CopyKeyLink = "Đã sao chép"
      }
    }
  })

       MinimizeButton({
       Image = "http://www.roblox.com/asset/?id=119198835819797",
       Size = {50, 50},
       Color = Color3.fromRGB(10, 10, 10),
       Corner = true,
       Stroke = false,
       StrokeColor = Color3.fromRGB(255, 0, 0)
      })
      
------ Tab
     local Tab1o = MakeTab({Name = "Trang chủ"})
     
     
-------TOGGLE 

     Toggle = AddToggle(Tab1o, {
      Name = "Chiriku Auto Hop Boss",
      Default = true,
      Callback = function()
     end
    })
    
------- BUTTON
    
    AddButton(Tab1o, {
     Name = "Auto Hop Rip_indra",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/AnDepZaiHub/AnBeoDepTrai/refs/heads/main/Rip_Indra"))()
end
})
   AddButton(Tab1o, {
     Name = "Auto Hop Dough King ",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/AnDepZaiHub/AnBeoDepTrai/refs/heads/main/Dough_King"))()
end
})
AddButton(Tab1o, {
     Name = "Auto Hop Mirage island (Wait Update)",
    Callback = function()
end
})
AddButton(Tab1o, {
     Name = "Auto Hop Black beard boss (Wait Update)",
    Callback = function()
end
})
AddButton(Tab1o, {
     Name = "Auto Hop legendery sword (Wait Update)",
    Callback = function()
end
})
AddButton(Tab1o, {
     Name = "Auto Hop Full Moon (Wait Update)",
    Callback = function()
end
})
AddButton(Tab1o, {
     Name = "Auto Hop Haki Legendery (Wait Update)",
    Callback = function()
end
})