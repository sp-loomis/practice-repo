import streamlit as st

def main():
    st.title("Welcome to My EC2 Practice App!")
    
    st.write("""
    This is a basic Streamlit app deployed on AWS EC2.
    Feel free to modify this to practice your cloud deployment skills!
    """)
    
    # Add a simple counter to demonstrate interactivity
    if 'count' not in st.session_state:
        st.session_state.count = 0
        
    st.write("## Interactive Counter")
    st.write(f"Current count: {st.session_state.count}")
    
    if st.button("Increment"):
        st.session_state.count += 1
        st.rerun()

if __name__ == "__main__":
    main()
