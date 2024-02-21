
import SwiftUI

struct ContentView: View {
    @State private var isGameViewPresented = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 255/255, green: 156/255, blue: 107/255), Color(red: 255/255, green: 97/255, blue: 58/255), Color(red: 67/255, green: 160/255, blue: 71/255)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            Image("fruitbg")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.top)
            
            
            
    
            
            ZStack{
                
            
                Button(action: {
                    self.isGameViewPresented = true
                }) {
                    Text("Start 🆂🅻🅸🅲🅴🆈")
                       
                        .fontWeight(.heavy)
                        .font(.system(size: 25))
                        .foregroundColor(.green)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding()
                .fullScreenCover(isPresented: $isGameViewPresented) {
                    GameView()
                } 
                
                ZStack {
                    Text("Healthy foods are like superheroes for your body! They give you energy, help you grow strong, and keep you feeling great.").font(.custom("AmericanTypewriter", size: 20))
                }
                .frame(width: 750, height: 200)
                .padding()
                .overlay( /// apply a rounded border
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(.green, lineWidth: 5)
                )
                .cornerRadius(50)
                .offset(y: -170)

                
                ZStack{
                    Text("Junk foods are like sneaky villains that try to trick your body. They might taste yummy, but they don't give your body the good stuff it needs to stay healthy.")
                    .font(.custom("AmericanTypewriter", size: 20))
                    
                }.frame(width: 750, height: 200)
                    .padding()
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.orange, lineWidth: 5)
                    )
                    .cornerRadius(50).offset(y: 170)

                
            }.frame(width: 800,height: 600)
                .background(Color.white).cornerRadius(50)
          
                
    //                Text("Avoid junk foods and promote healthy eating habits❗️").font(.custom("AmericanTypewriter", size: 25))

            
     .multilineTextAlignment(.center)


            //                

                           
            //                    .padding()
            //                    .foregroundStyle(.white)
            //                   
            //                    .padding()
                          
            ZStack{

                Text("Slice the fruits images🍎🍌🥝 and avoid slicing the junk food images🍟🍔🌭").font(.system(size:35)).fontWeight(.heavy).foregroundColor(.white)
            }.frame(width: 600,height: 200)
             .cornerRadius(50).offset(y: 410)     .multilineTextAlignment(.center)
            
        } 
        
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

