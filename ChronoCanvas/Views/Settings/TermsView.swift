//  TermsView.swift

import SwiftUI

struct TermsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text("1. はじめに\n本利用規約（以下「本規約」といいます）は、CHRONO CANVAS（以下「本アプリ」といいます）の提供条件および運営者と本アプリのユーザー（以下「ユーザー」といいます）との間の権利義務関係を定めるものです。ユーザーは、本アプリを利用する前に、本規約をよく読み、その内容を理解し、同意した上で本アプリを利用してください。")
                        .padding(.bottom)
                    Text("2. サービスの利用\nユーザーは、本アプリを通じて、スケジューラ作成やイベント管理などの機能を利用できます。本アプリでは、これらの情報がアプリ内に保存され、ユーザーの利便性向上のために使用されます。")
                        .padding(.bottom)
                    Text("3. 禁止事項\nユーザーは、法令または公序良俗に違反する行為、他のユーザーの体験を害する行為、運営者のサービス運営を妨害する行為などを行ってはなりません。また、本アプリの著作権を侵害する行為や不正な方法によるデータの操作も禁止されています。")
                        .padding(.bottom)
                }
                Group {
                    Text("4. 広告について\n本アプリは、広告を表示することにより収益を得ています。本アプリでは、Google AdMobなどの広告プラットフォームを利用しており、広告表示のためにデバイスの識別情報を使用することがあります。ユーザーは、設定にて広告トラッキングを制御することができます。")
                        .padding(.bottom)
                    Text("5. 免責事項\n運営者は、本アプリに関して、その完全性、正確性、確実性等について一切保証しません。また、本アプリの利用により生じた損害について、運営者は責任を負わないものとします。ユーザーは自己の責任において本アプリを利用するものとします。")
                        .padding(.bottom)
                    Text("6. 規約の変更\n運営者は、必要と判断した場合には、ユーザーに通知することなく、本規約を変更することができます。変更後の規約に同意できない場合、ユーザーはサービスの利用を中止する権利があります。")
                        .padding(.bottom)
                }
                Group {
                    Text("7. 連絡先\n本アプリに関するお問い合わせやご意見は、運営者の公式メールアドレスまでお願いします。")
                        .padding(.bottom)
                }
                
                Spacer()
                    .frame(height: 50)
            }
            .padding()
        }
        .navigationTitle("利用規約")
    }
}